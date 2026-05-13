# Example: Bug Fix (Systematic Debugging)

**Real-world example of using SuperBob to fix a bug systematically**

---

## Scenario

**Bug Report:** "Login fails when password field is empty"

**Symptoms:**
- User clicks login with empty password
- Application crashes with 500 error
- No error message shown to user

**Starting point:** Bug exists in production

**Goal:** Fix bug properly with root cause investigation

---

## Workflow Used

**Workflow 3: Bug Investigation**

1. Systematic Debugging → 4-phase investigation
2. Test-Driven Development → Implement fix
3. Auto-review → Verify fix quality
4. Finishing → Complete the work

---

## Step 1: Systematic Debugging (Investigation)

**Mode:** `systematic-debugging`

**User:** "/debug - Login fails when password is empty"

**AI (systematic-debugging mode):**

```
I'm using the systematic-debugging skill to investigate this bug.

Starting 4-phase investigation...
```

### Phase 1: Root Cause Investigation

**AI:**

```
**Phase 1: Root Cause Investigation**

Step 1: Reproduce the bug consistently

Attempting to reproduce...
$ curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":""}'

Response:
HTTP/1.1 500 Internal Server Error
{
  "error": "Internal Server Error"
}

Server logs:
TypeError: Cannot read property 'length' of undefined
    at bcrypt.compare (auth.js:45)
    at login (auth.js:42)

Bug reproduced consistently ✓

Step 2: Check recent changes

$ git log --oneline --since="1 week ago" -- auth.js
abc1234 Refactor login validation
def5678 Add rate limiting

Recent change to validation logic - potential cause.

Step 3: Trace data flow

Request → login controller → password validation → bcrypt.compare

Looking at auth.js:42...
```

**Reading code:**

```javascript
// auth.js:42
async function login(req, res) {
  const { email, password } = req.body;
  
  const user = await User.findByEmail(email);
  if (!user) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  
  // Line 45: Bug is here
  const isValid = await bcrypt.compare(password, user.password);
  if (!isValid) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  
  // Generate token...
}
```

**AI:**

```
**Root cause identified:**

bcrypt.compare() is called with empty string password.
When password is empty, bcrypt throws TypeError.

**Why it happens:**
- Validation was removed in commit abc1234
- Empty password reaches bcrypt.compare()
- bcrypt expects non-empty string

**Original trigger:**
Refactoring removed password validation without adding it back.
```

---

### Phase 2: Pattern Analysis

**AI:**

```
**Phase 2: Pattern Analysis**

Looking for similar validation patterns in codebase...

$ grep -r "bcrypt.compare" --include="*.js"
auth.js:45:  const isValid = await bcrypt.compare(password, user.password);
reset.js:23:  const isValid = await bcrypt.compare(token, user.resetToken);

Checking reset.js for comparison...
```

**Reading reset.js:**

```javascript
// reset.js:20
async function resetPassword(req, res) {
  const { token, newPassword } = req.body;
  
  // Has validation!
  if (!token || !newPassword) {
    return res.status(400).json({ error: 'Token and password required' });
  }
  
  const isValid = await bcrypt.compare(token, user.resetToken);
  // ...
}
```

**AI:**

```
**Pattern found:**

reset.js validates inputs BEFORE bcrypt.compare()
auth.js is missing this validation

**Difference:**
✓ reset.js: Validates → then bcrypt
✗ auth.js: No validation → bcrypt crashes

**Correct pattern:**
Always validate inputs before passing to bcrypt.
```

---

### Phase 3: Hypothesis Testing

**AI:**

```
**Phase 3: Hypothesis Testing**

**Hypothesis:**
Adding validation before bcrypt.compare() will prevent the crash.

**Test hypothesis minimally:**

Creating test file to verify...
```

**Test code:**

```javascript
// test-hypothesis.js
const bcrypt = require('bcrypt');

async function testEmptyPassword() {
  try {
    // This should crash (current behavior)
    await bcrypt.compare('', 'hashed_password');
    console.log('No crash - hypothesis wrong');
  } catch (err) {
    console.log('Crashed as expected:', err.message);
  }
  
  // With validation (proposed fix)
  const password = '';
  if (!password) {
    console.log('Validation caught empty password');
    return;
  }
  await bcrypt.compare(password, 'hashed_password');
}

testEmptyPassword();
```

**Running test:**

```
$ node test-hypothesis.js
Crashed as expected: data must be a string or Buffer and salt must be a string or Buffer
Validation caught empty password

Hypothesis confirmed ✓
```

**AI:**

```
**Hypothesis confirmed:**
- Empty password causes bcrypt to crash
- Validation before bcrypt prevents crash
- Fix: Add validation like reset.js has
```

---

### Phase 4: Implementation (with TDD)

**AI:**

```
**Phase 4: Implementation**

Now implementing fix using TDD...

Spawning test-driven-development mode...
```

**Subagent (TDD mode):**

```
**RED Phase:**
Writing test that reproduces the bug...

// tests/auth.test.js
describe('POST /auth/login', () => {
  it('should reject empty password with 400', async () => {
    const response = await request(app)
      .post('/auth/login')
      .send({
        email: 'test@example.com',
        password: ''
      });
    
    expect(response.status).toBe(400);
    expect(response.body.error).toContain('Password required');
  });
  
  it('should reject missing password with 400', async () => {
    const response = await request(app)
      .post('/auth/login')
      .send({
        email: 'test@example.com'
      });
    
    expect(response.status).toBe(400);
    expect(response.body.error).toContain('Password required');
  });
});

Running tests...
$ npm test tests/auth.test.js
✗ should reject empty password with 400
  Expected: 400
  Received: 500

✗ should reject missing password with 400
  Expected: 400
  Received: 500

Tests fail as expected (bug exists) - RED ✓

**GREEN Phase:**
Implementing fix...

// auth.js
async function login(req, res) {
  const { email, password } = req.body;
  
  // ADD VALIDATION (fix)
  if (!email || !password) {
    return res.status(400).json({ 
      error: 'Email and password required' 
    });
  }
  
  const user = await User.findByEmail(email);
  if (!user) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  
  const isValid = await bcrypt.compare(password, user.password);
  if (!isValid) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  
  // Generate token...
}

Running tests...
$ npm test tests/auth.test.js
✓ should reject empty password with 400
✓ should reject missing password with 400
✓ all other login tests still pass

Tests pass - GREEN ✓

**REFACTOR Phase:**
Extract validation to reusable middleware...

// middleware/validate.js
function validateLoginInput(req, res, next) {
  const { email, password } = req.body;
  
  if (!email || !password) {
    return res.status(400).json({ 
      error: 'Email and password required' 
    });
  }
  
  next();
}

// auth.js
router.post('/login', validateLoginInput, login);

Tests still pass after refactor ✓

Committing...
$ git add auth.js middleware/validate.js tests/auth.test.js
$ git commit -m "Fix: Validate password before bcrypt to prevent crash"
[feature/fix-login-crash xyz9876] Fix: Validate password before bcrypt to prevent crash

Fix complete. Self-review: Root cause addressed, tests pass, follows TDD.
```

---

## Step 2: Auto-Review

**Mode:** `requesting-code-review` (auto-spawned)

**AI (code reviewer):**

```
Reviewing bug fix implementation...

**Requirements Check:**
✓ Bug reproduced with test
✓ Root cause identified (missing validation)
✓ Fix addresses root cause (not symptom)
✓ Tests verify fix works
✓ Existing tests still pass

**Code Quality:**
✓ Validation extracted to middleware (reusable)
✓ Error messages clear
✓ Follows existing patterns (like reset.js)
✓ No security issues introduced

**Testing:**
✓ Test reproduces original bug
✓ Test verifies fix works
✓ Edge cases covered (empty, missing)

**Assessment:** ✅ APPROVED

No issues found. Fix is clean and addresses root cause.
```

---

## Step 3: Verification

**AI (back to debugging mode):**

```
**Verification:**

Testing the fix manually...

$ curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":""}'

Response:
HTTP/1.1 400 Bad Request
{
  "error": "Email and password required"
}

✓ No crash
✓ Clear error message
✓ Correct status code (400)

Bug fixed successfully ✓
```

---

## Step 4: Finishing

**Mode:** `finishing-a-development-branch`

**AI:**

```
I'm using the finishing-a-development-branch skill to complete this work.

**Step 1: Verify Tests**
$ npm test
✓ 45/45 tests passing

**Step 2: Present Options**
Bug fix complete. What would you like to do?

1. Merge back to main locally
2. Push and create a Pull Request
3. Keep the branch as-is
4. Discard this work

Which option?
```

**User:** "2 - Create PR"

**AI:**

```
Creating Pull Request...

$ gh pr create --title "Fix: Login crash with empty password" --body "..."

Pull Request created: #124
https://github.com/company/app/pull/124

**PR Description includes:**
- Root cause analysis
- Investigation process
- Test demonstrating bug
- Fix implementation
- Verification results

Complete! Bug fixed and PR created.
```

---

## Results

**What was delivered:**
- ✅ Root cause identified (missing validation)
- ✅ Bug reproduced with test
- ✅ Fix implemented with TDD
- ✅ All tests passing
- ✅ Code reviewed and approved
- ✅ Ready for production

**Time taken:** 45 minutes

**Quality metrics:**
- Root cause found: Yes (not symptom patched)
- Tests added: 2 new tests
- Regression risk: Low (validation only)
- Code review: Approved

---

## Key Takeaways

1. **Systematic investigation** - 4 phases prevented quick fix
2. **Root cause found** - Missing validation, not bcrypt issue
3. **Pattern analysis** - Found correct pattern in reset.js
4. **Hypothesis tested** - Verified fix before implementing
5. **TDD enforced** - Test reproduced bug, then fixed
6. **Auto-review** - Caught potential issues early

**Comparison to "quick fix":**

**Without SuperBob (quick fix):**
- Add try-catch around bcrypt.compare()
- Patches symptom, not cause
- Bug could reappear elsewhere
- No test added
- Time: 10 minutes
- Quality: Low

**With SuperBob (systematic):**
- Found root cause (missing validation)
- Fixed properly with pattern
- Added tests to prevent regression
- Code reviewed
- Time: 45 minutes
- Quality: High

**Result:** 35 extra minutes prevented future bugs and tech debt.