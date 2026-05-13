# Example: Design Session (Brainstorming)

**Real-world example of using SuperBob for design exploration**

---

## Scenario

**Request:** "We need to add caching to improve API performance"

**Context:**
- API currently hits database for every request
- Response times are slow (500-1000ms)
- Same data requested frequently
- Need to reduce database load

**Starting point:** No caching exists

**Goal:** Design a caching solution before implementing

---

## Workflow Used

**Workflow 4: Design Exploration**

1. Brainstorming → Explore approaches
2. Design refinement → Incremental validation
3. Document design → Save to docs/plans/
4. Optional: Continue to implementation

---

## Step 1: Understanding the Problem

**Mode:** `brainstorming`

**User:** "/brainstorm - We need to add caching to improve API performance"

**AI (brainstorming mode):**

```
Let me understand the requirements first.

Checking current project state...
- API framework: Express.js
- Database: PostgreSQL
- Current response time: 500-1000ms
- Traffic: ~1000 req/min

What data needs caching?
1. All API responses
2. Specific endpoints only
3. Database query results
4. Computed/expensive operations
```

**User:** "Specific endpoints - user profiles and product listings"

**AI:**

```
How long should cached data remain valid?
1. Short (1-5 minutes) - fresher data
2. Medium (5-30 minutes) - balanced
3. Long (30+ minutes) - better performance
4. Varies by endpoint
```

**User:** "Varies - user profiles can be 30 min, products need 5 min"

**AI:**

```
What happens when data changes?
1. Wait for cache to expire (simple)
2. Invalidate cache on updates (complex but accurate)
3. Hybrid - expire + manual invalidation
```

**User:** "Hybrid approach"

---

## Step 2: Exploring Approaches

**AI:**

```
I'll propose 3 different caching approaches with trade-offs.

**Option A: In-Memory Cache (Node.js)**

**How it works:**
- Store cache in Node.js process memory
- Use Map or node-cache library
- Automatic expiration with TTL

**Pros:**
- Simple to implement
- No external dependencies
- Fast (in-process)
- Good for single-server setups

**Cons:**
- Lost on server restart
- Not shared across multiple servers
- Memory limited by Node.js heap
- Can't scale horizontally

**Best for:**
- Development/staging
- Single-server deployments
- Low-traffic applications
- Quick MVP

**Implementation complexity:** Low (2-3 hours)

---

**Option B: Redis Cache (Recommended)**

**How it works:**
- External Redis server stores cache
- All app servers share same cache
- Persistent across restarts
- Built-in TTL and eviction

**Pros:**
- Shared across multiple servers
- Survives restarts
- Scales horizontally
- Rich features (pub/sub for invalidation)
- Industry standard

**Cons:**
- Requires Redis infrastructure
- Network latency (small)
- More complex setup
- Additional monitoring needed

**Best for:**
- Production systems
- Multi-server deployments
- High-traffic applications
- Long-term solution

**Implementation complexity:** Medium (4-6 hours)

---

**Option C: CDN + Redis Hybrid**

**How it works:**
- CDN caches at edge (Cloudflare, CloudFront)
- Redis caches at application layer
- Two-tier caching strategy

**Pros:**
- Fastest for global users
- Reduces server load dramatically
- Redis handles dynamic content
- CDN handles static/semi-static

**Cons:**
- Most complex setup
- CDN costs
- Cache invalidation across two layers
- Requires CDN configuration

**Best for:**
- Global applications
- High traffic (10k+ req/min)
- Static + dynamic content mix
- Performance-critical systems

**Implementation complexity:** High (8-12 hours)

---

**My recommendation: Option B (Redis)**

**Why:**
- You have multiple servers (need shared cache)
- Traffic is moderate (1000 req/min)
- Need persistence across restarts
- Room to grow
- Industry standard (easy to hire for)

**Start with Redis, add CDN later if needed.**

Does this approach look right?
```

**User:** "Yes, Redis makes sense. How would we structure it?"

---

## Step 3: Design Refinement

**AI:**

```
Let me present the design incrementally...

**Section 1: Architecture Overview**

**Components:**
1. Redis server (cache storage)
2. Cache middleware (Express.js)
3. Cache invalidation service
4. Monitoring/metrics

**Data flow:**
```
Request → Cache Middleware
              ↓
         Check Redis
              ↓
         Cache Hit? → Return cached response
              ↓ No
         Call handler → Get from DB
              ↓
         Store in Redis (with TTL)
              ↓
         Return response
```

**Cache keys:**
- User profiles: `user:profile:{userId}`
- Product listings: `products:list:{page}:{filters}`

**TTL strategy:**
- User profiles: 30 minutes
- Product listings: 5 minutes

Does this structure make sense?
```

**User:** "Yes, continue"

**AI:**

```
**Section 2: Cache Invalidation Strategy**

**When to invalidate:**

**User profiles:**
- User updates profile → Invalidate `user:profile:{userId}`
- User deletes account → Invalidate `user:profile:{userId}`

**Product listings:**
- Product created → Invalidate all `products:list:*`
- Product updated → Invalidate all `products:list:*`
- Product deleted → Invalidate all `products:list:*`

**Implementation:**
```javascript
// After user update
await User.update(userId, data);
await cache.del(`user:profile:${userId}`);

// After product change
await Product.create(data);
await cache.delPattern('products:list:*');
```

**Pub/Sub for multi-server:**
- Server A updates user → Publishes invalidation event
- Servers B, C, D → Subscribe and invalidate local cache

Does this invalidation strategy work?
```

**User:** "Yes, but what about race conditions?"

**AI:**

```
Good catch! Let me address race conditions...

**Section 3: Race Condition Handling**

**Problem:**
```
Time 0: Request A reads from DB (user age: 25)
Time 1: Request B updates user (age: 26)
Time 2: Request B invalidates cache
Time 3: Request A writes stale data to cache (age: 25)
Result: Cache has wrong data for 30 minutes
```

**Solution: Cache versioning**

**Approach:**
- Include version/timestamp in cache key
- Check version before writing to cache
- Reject stale writes

**Implementation:**
```javascript
async function cacheWithVersion(key, data, ttl) {
  const version = Date.now();
  const cacheKey = `${key}:v${version}`;
  
  // Store with version
  await redis.setex(cacheKey, ttl, JSON.stringify({
    data,
    version,
    cachedAt: version
  }));
  
  // Store version pointer
  await redis.set(`${key}:version`, version);
}

async function getFromCache(key) {
  const version = await redis.get(`${key}:version`);
  if (!version) return null;
  
  const cached = await redis.get(`${key}:v${version}`);
  return cached ? JSON.parse(cached) : null;
}
```

**Alternative: Optimistic locking**
- Use Redis WATCH/MULTI/EXEC
- Atomic check-and-set operations

Does this address the race condition concern?
```

**User:** "Yes, that works"

**AI:**

```
**Section 4: Error Handling**

**Cache failures should not break the app:**

**Strategy: Graceful degradation**
```javascript
async function getCachedOrFetch(key, fetchFn, ttl) {
  try {
    // Try cache first
    const cached = await cache.get(key);
    if (cached) return cached;
  } catch (err) {
    // Cache error - log but continue
    logger.error('Cache read failed', err);
  }
  
  // Fetch from source
  const data = await fetchFn();
  
  try {
    // Try to cache result
    await cache.set(key, data, ttl);
  } catch (err) {
    // Cache write failed - log but continue
    logger.error('Cache write failed', err);
  }
  
  return data;
}
```

**Monitoring:**
- Cache hit rate (target: >80%)
- Cache errors (alert if >1%)
- Response time improvement
- Redis memory usage

**Circuit breaker:**
- If Redis fails repeatedly, bypass cache temporarily
- Prevents cascading failures

Does this error handling look sufficient?
```

**User:** "Yes, looks good"

---

## Step 4: Document Design

**AI:**

```
Writing design document...

Saved to: docs/plans/2026-05-13-caching-design.md

**Design Summary:**

**Approach:** Redis-based caching with TTL and invalidation

**Components:**
- Redis server (cache storage)
- Cache middleware (Express.js)
- Invalidation service (pub/sub)
- Monitoring (metrics + alerts)

**Key Decisions:**
- Redis over in-memory (multi-server support)
- Hybrid invalidation (TTL + manual)
- Version-based race condition prevention
- Graceful degradation on cache failures

**TTL Strategy:**
- User profiles: 30 minutes
- Product listings: 5 minutes

**Invalidation:**
- User updates → Invalidate specific user
- Product changes → Invalidate all product lists
- Pub/sub for multi-server coordination

**Error Handling:**
- Graceful degradation
- Circuit breaker pattern
- Comprehensive monitoring

**Estimated Implementation:**
- Setup Redis: 1 hour
- Cache middleware: 2 hours
- Invalidation service: 2 hours
- Testing + monitoring: 1 hour
- Total: 6 hours

Ready to create implementation plan?
1. Yes - create detailed plan
2. No - design is sufficient for now
```

**User:** "Yes, create implementation plan"

---

## Step 5: Create Implementation Plan

**Mode:** `writing-plans` (spawned by brainstorming)

**AI:**

```
Creating detailed implementation plan...

Plan saved to: docs/plans/2026-05-13-caching-implementation.md

**Plan Summary:**
- 7 tasks total
- Each task with TDD requirements
- Estimated: 6 hours
- Ready for execution

Would you like to execute this plan now?
1. Execute in this session
2. Execute later with /execute-plan
3. Just keep the plan for reference
```

**User:** "Keep for reference - I'll execute tomorrow"

**AI:**

```
Design complete!

**Deliverables:**
✓ Design document: docs/plans/2026-05-13-caching-design.md
✓ Implementation plan: docs/plans/2026-05-13-caching-implementation.md

**Next steps:**
When ready to implement:
1. Use /execute-plan or select executing-plans mode
2. Reference: docs/plans/2026-05-13-caching-implementation.md
3. TDD will be enforced for all tasks
4. Auto-review after each task

Design session complete!
```

---

## Results

**What was delivered:**
- ✅ 3 approaches explored with trade-offs
- ✅ Redis approach selected with reasoning
- ✅ Complete architecture designed
- ✅ Race conditions addressed
- ✅ Error handling strategy defined
- ✅ Design document created
- ✅ Implementation plan ready

**Time taken:** 1 hour

**Quality metrics:**
- Approaches explored: 3
- Trade-offs analyzed: Yes
- Edge cases considered: Race conditions, errors
- Documentation: Complete
- Ready for implementation: Yes

---

## Key Takeaways

1. **Socratic questioning** - AI asked clarifying questions first
2. **Multiple approaches** - Explored 3 options before deciding
3. **Trade-off analysis** - Pros/cons for each approach
4. **Incremental validation** - Presented design in sections
5. **Edge cases addressed** - Race conditions, error handling
6. **Documentation created** - Design + implementation plan

**Comparison to "just start coding":**

**Without brainstorming:**
- Pick first solution (probably in-memory)
- Discover limitations later
- Rework needed
- Time wasted: 4-8 hours

**With brainstorming:**
- Explored 3 approaches
- Selected best for requirements
- Addressed edge cases upfront
- Ready for clean implementation
- Time invested: 1 hour design

**Result:** 1 hour of design saved 4-8 hours of rework.

---

## Design Document Excerpt

**From docs/plans/2026-05-13-caching-design.md:**

```markdown
# Caching System Design

## Decision: Redis-based Caching

**Why Redis:**
- Multi-server support (we have 3 app servers)
- Persistence across restarts
- Industry standard (easy to hire for)
- Rich features (pub/sub, TTL, patterns)
- Room to grow

**Why not in-memory:**
- Not shared across servers
- Lost on restart
- Can't scale horizontally

**Why not CDN (yet):**
- Overkill for current traffic (1000 req/min)
- Can add later if needed
- Start simple, add complexity when justified

## Architecture

[Detailed architecture diagrams and implementation details...]

## Implementation Plan

See: docs/plans/2026-05-13-caching-implementation.md

Ready for execution with TDD enforcement.
```

---

## When to Use This Workflow

**Use brainstorming when:**
- Multiple approaches possible
- Trade-offs need analysis
- Design not obvious
- Edge cases need consideration
- Team needs alignment

**Skip brainstorming when:**
- Solution is obvious
- Single clear approach
- Simple, well-understood problem
- Time-critical bug fix

**Result:** Better designs, less rework, clearer documentation.