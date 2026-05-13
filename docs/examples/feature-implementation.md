# Example: Feature Implementation (Authentication System)

**Real-world example of using SuperBob to implement a complete feature**

---

## Scenario

Add user authentication to an existing web application:
- Email/password login
- JWT token generation
- Protected routes
- Session management

**Starting point:** Application has no authentication

**Goal:** Complete, tested authentication system

---

## Workflow Used

**Workflow 1: Feature Implementation (Full Cycle)**

1. Brainstorming → Design refinement
2. Writing Plans → Detailed implementation plan
3. Executing Plans → Batch execution with TDD
4. Auto-review → After each task
5. Finishing → Merge to main

---

## Step 1: Brainstorming (Design Refinement)

**Mode:** `brainstorming`

**User:** "I need to add user authentication to the app"

**AI (brainstorming mode):**

```
Let me understand the requirements first.

What authentication method do you want?
1. Email/password (traditional)
2. OAuth (Google, GitHub, etc.)
3. Magic links (passwordless)
4. Multiple options
```

**User:** "Email/password for now"

**AI:**

```
How should sessions be managed?
1. JWT tokens (stateless)
2. Server-side sessions (stateful)
3. Hybrid approach
```

**User:** "JWT tokens"

**AI:**

```
I'll propose 3 approaches:

**Option A: Simple JWT (Recommended for MVP)**
- Pros: Simple, stateless, scales well
- Cons: Can't revoke tokens easily
- Best for: Getting started quickly

**Option B: JWT + Refresh Tokens**
- Pros: Can revoke access, better security
- Cons: More complex, needs token storage
- Best for: Production systems

**Option C: JWT + Redis Blacklist**
- Pros: Can revoke, still mostly stateless
- Cons: Adds Redis dependency
- Best for: High-security requirements

Recommendation: Start with Option A, migrate to B later if needed.
```

**User:** "Let's go with Option A"

**AI:**

```
Design overview:

**Architecture:**
- POST /auth/register - Create new user
- POST /auth/login - Authenticate, return JWT
- Middleware to verify JWT on protected routes
- Password hashing with bcrypt
- JWT signing with secret key

**Components:**
1. User model (email, password hash)
2. Auth controller (register, login)
3. JWT middleware (verify token)
4. Password utilities (hash, compare)

**Security:**
- Passwords hashed with bcrypt (cost 10)
- JWT expires in 24 hours
- HTTPS required in production
- Rate limiting on auth endpoints

Writing design to docs/plans/2026-05-13-auth-design.md...
```

---

## Step 2: Writing Plans (Implementation Plan)

**Mode:** `writing-plans`

**AI:**

```
Creating detailed implementation plan...

Plan saved to: docs/plans/2026-05-13-auth-implementation.md

**Summary:**
- 8 tasks total
- Estimated: 3-4 hours
- TDD enforced for all tasks
- Auto-review after each task

Ready to execute plan?
1. Execute in this session (subagent-driven-development)
2. Execute later (I'll run /execute-plan)
```

**User:** "Execute in this session"

---

## Step 3: Executing Plans (Implementation)

**Mode:** `subagent-driven-development`

**AI:**

```
I'm using Subagent-Driven Development to execute this plan.

Reading plan: docs/plans/2026-05-13-auth-implementation.md
Extracted 8 tasks with full context.

Starting Task 1: User Model
```

### Task 1: User Model

**Subagent (TDD mode):**

```
Task 1: Create User model with email and password fields

**RED Phase:**
Writing failing test...

// tests/models/user.test.js
describe('User Model', () => {
  it('should create user with email and hashed password', async () => {
    const user = await User.create({
      email: 'test@example.com',
      password: 'password123'
    });
    
    expect(user.email).toBe('test@example.com');
    expect(user.password).not.toBe('password123'); // Should be hashed
    expect(user.password).toMatch(/^\$2[aby]\$/); // bcrypt format
  });
});

Running test...
$ npm test tests/models/user.test.js
✗ User Model › should create user with email and hashed password
  Error: User is not defined

Test fails as expected (RED) ✓

**GREEN Phase:**
Implementing User model...

// models/user.js
const bcrypt = require('bcrypt');

class User {
  constructor(email, password) {
    this.email = email;
    this.password = password;
  }
  
  static async create({ email, password }) {
    const hashedPassword = await bcrypt.hash(password, 10);
    return new User(email, hashedPassword);
  }
}

module.exports = User;

Running test...
$ npm test tests/models/user.test.js
✓ User Model › should create user with email and hashed password

Test passes (GREEN) ✓

**REFACTOR Phase:**
Code is clean, no refactoring needed.

Committing...
$ git add models/user.js tests/models/user.test.js
$ git commit -m "Add User model with password hashing"
[feature/auth abc1234] Add User model with password hashing

Task 1 complete. Self-review: Implementation matches spec, tests pass, follows TDD.
```

**Spec Compliance Review:**

```
Reviewing Task 1 against specification...

**Requirements:**
✓ User model created
✓ Email field present
✓ Password hashing implemented
✓ Tests written and passing

**Spec compliance:** ✅ APPROVED
```

**Code Quality Review:**

```
Reviewing code quality for Task 1...

**Strengths:**
- Clean implementation
- Proper bcrypt usage
- Good test coverage

**Issues:** None

**Assessment:** ✅ APPROVED
```

**AI (orchestrator):**

```
Task 1 complete. Moving to Task 2...
```

### Task 2: Auth Controller (Register)

**Subagent (TDD mode):**

```
Task 2: Implement registration endpoint

**RED Phase:**
Writing failing test...

// tests/controllers/auth.test.js
describe('POST /auth/register', () => {
  it('should register new user', async () => {
    const response = await request(app)
      .post('/auth/register')
      .send({
        email: 'newuser@example.com',
        password: 'password123'
      });
    
    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('user');
    expect(response.body.user.email).toBe('newuser@example.com');
  });
  
  it('should reject duplicate email', async () => {
    await User.create({ email: 'existing@example.com', password: 'pass' });
    
    const response = await request(app)
      .post('/auth/register')
      .send({
        email: 'existing@example.com',
        password: 'password123'
      });
    
    expect(response.status).toBe(400);
    expect(response.body.error).toContain('already exists');
  });
});

Running tests...
$ npm test tests/controllers/auth.test.js
✗ Both tests fail (endpoint doesn't exist)

Tests fail as expected (RED) ✓

**GREEN Phase:**
Implementing register endpoint...

// controllers/auth.js
const User = require('../models/user');

async function register(req, res) {
  const { email, password } = req.body;
  
  // Check if user exists
  const existing = await User.findByEmail(email);
  if (existing) {
    return res.status(400).json({ error: 'Email already exists' });
  }
  
  // Create user
  const user = await User.create({ email, password });
  
  res.status(201).json({ user: { email: user.email } });
}

module.exports = { register };

Running tests...
$ npm test tests/controllers/auth.test.js
✓ should register new user
✓ should reject duplicate email

Tests pass (GREEN) ✓

**REFACTOR Phase:**
Extract validation to middleware...

// middleware/validate.js
function validateRegister(req, res, next) {
  const { email, password } = req.body;
  
  if (!email || !email.includes('@')) {
    return res.status(400).json({ error: 'Invalid email' });
  }
  
  if (!password || password.length < 8) {
    return res.status(400).json({ error: 'Password must be 8+ characters' });
  }
  
  next();
}

Tests still pass after refactor ✓

Committing...
$ git commit -m "Add user registration endpoint with validation"
```

**Reviews pass, Task 2 complete.**

---

## Step 4: Continuing Through All Tasks

**Tasks 3-8 follow same pattern:**
- Task 3: Login endpoint (TDD)
- Task 4: JWT generation (TDD)
- Task 5: JWT middleware (TDD)
- Task 6: Protected routes (TDD)
- Task 7: Error handling (TDD)
- Task 8: Integration tests (TDD)

**Each task:**
1. Subagent implements with TDD
2. Spec compliance review
3. Code quality review
4. Move to next task

---

## Step 5: Finishing (Completion)

**Mode:** `finishing-a-development-branch`

**AI:**

```
I'm using the finishing-a-development-branch skill to complete this work.

**Step 1: Verify Tests**
Running full test suite...

$ npm test
✓ User Model (3 tests)
✓ Auth Controller (8 tests)
✓ JWT Middleware (5 tests)
✓ Integration Tests (6 tests)

22/22 tests passing ✓

**Step 2: Present Options**
Implementation complete. What would you like to do?

1. Merge back to main locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**User:** "2 - Create PR"

**AI:**

```
Pushing branch...
$ git push -u origin feature/auth
[pushed successfully]

Creating Pull Request...
$ gh pr create --title "Add user authentication system" --body "..."

Pull Request created: #123
https://github.com/company/app/pull/123

Cleaning up worktree...
$ git worktree remove .worktrees/feature-auth

Complete! Authentication system implemented and PR created.
```

---

## Results

**What was delivered:**
- ✅ Complete authentication system
- ✅ 22 tests, all passing
- ✅ TDD followed for all code
- ✅ Auto-review after each task
- ✅ Clean, maintainable code
- ✅ Ready for production

**Time taken:** 3.5 hours

**Quality metrics:**
- Test coverage: 95%
- Code review: All tasks approved
- Bugs found: 0 (caught in review)
- Rework needed: Minimal

---

## Key Takeaways

1. **Brainstorming first** - Explored 3 approaches before committing
2. **Detailed planning** - 8 clear tasks with TDD requirements
3. **TDD enforced** - Every task followed RED-GREEN-REFACTOR
4. **Auto-review** - Caught issues early (before they compound)
5. **Two-stage review** - Spec compliance + code quality
6. **Clean completion** - PR created, worktree cleaned up

**Result:** High-quality feature delivered with confidence.