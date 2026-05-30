# Planning Protocol

## Fase di Intervista (obbligatoria prima del codice)
Prima di scrivere una riga di codice, rispondi a queste domande:

1. **Core Problem**: Qual è il problema principale? (non la soluzione — il problema)
2. **Success Criteria**: Quali test devono passare? Quale comportamento osservabile?
3. **Non-Goals**: Cosa questa implementazione NON deve toccare?
4. **Impatto**: Quali file/moduli esistenti saranno toccati?

## Verification Plan
- Elenca i passi di implementazione in ordine.
- Per ogni passo, indica come verificarlo.
- Identifica le dipendenze tra i passi.

## Poi procedi
Solo dopo conferma sull'alignment, inizia l'implementazione.

## Regola del Doppio Contesto
Per decisioni architetturali importanti: fai scrivere il piano in una sessione,
poi apri una sessione fresca e chiedi una review da staff engineer senza contesto
da implementazione. La sessione fresca non ha bias e cattura gap reali.
