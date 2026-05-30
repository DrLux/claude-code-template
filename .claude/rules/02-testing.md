# Testing

## Framework
pytest + pytest-asyncio for async code.

## Strategy
- Every public function: at least 3 cases — happy path, edge case, error case.
- `@pytest.mark.parametrize` for variants of the same case.
- Fixtures in `conftest.py`, not in the test file.
- Mock only external I/O (HTTP, DB, filesystem). Never mock business logic.
- `@pytest.mark.asyncio` for async functions.

## Naming
`test_<function>_<scenario>_<expected_outcome>`
Example: `test_create_user_with_duplicate_email_raises_conflict`

## Coverage
- Minimum threshold: 80% on `src/`.
- Do not inflate coverage with placeholder tests or empty asserts.
- Coverage < 80% on new code blocks the merge.

## Fundamental Rule
Do not commit with failing tests. The `Stop` hook runs pytest automatically
and blocks if they fail.
