# Testing

## Framework
pytest + pytest-asyncio per codice async.

## Strategia
- Ogni funzione pubblica: almeno 3 casi — happy path, edge case, error case.
- `@pytest.mark.parametrize` per varianti dello stesso caso.
- Fixtures in `conftest.py`, non nel file di test.
- Mock solo per I/O esterni (HTTP, DB, filesystem). Mai mockare business logic.
- `@pytest.mark.asyncio` per funzioni async.

## Naming
`test_<funzione>_<scenario>_<expected_outcome>`
Esempio: `test_create_user_with_duplicate_email_raises_conflict`

## Coverage
- Soglia minima: 80% su `src/`.
- Non incrementare la coverage con test placeholder o assert vuoti.
- Coverage < 80% su nuovo codice blocca il merge.

## Regola fondamentale
Non committare con test rossi. L'hook `Stop` esegue pytest automaticamente
e blocca se falliscono.
