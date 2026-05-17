import re

def run_skill_validator(code):
    errors = []

    # Rule: SELECT * is FORBIDDEN
    if re.search(r"SELECT\s+\*", code, re.IGNORECASE):
        errors.append("SQL Error: 'SELECT *' is forbidden. Use explicit column lists.")

    # Rule: Naming Conventions (Simplified check on code content or comments)
    # Note: In a real scenario, we'd check the filename, but here we check for markers.
    if not any(suffix in code for suffix in ["_repo", "_serv", "_main"]):
        errors.append("Architecture Error: Code must follow naming rules (*_repo, *_serv, *_main).")

    # Rule: Free-format RPGLE ONLY
    if "C     " in code or "D     " in code: # Simple check for fixed-format markers
        errors.append("RPGLE Error: Legacy fixed-format detected. Only free-format is allowed.")
    
    if "dcl-proc" not in code.lower() and "dcl-s" not in code.lower() and "dcl-pi" not in code.lower():
        # This is a bit loose but checks for modern dcl-* usage
        errors.append("RPGLE Error: Use procedures (dcl-proc) and modern declarations.")

    # Rule: No GOTO/MOVE/MOVEL
    if re.search(r"\b(GOTO|MOVE|MOVEL)\b", code, re.IGNORECASE):
        errors.append("RPGLE Error: GOTO, MOVE, and MOVEL are forbidden.")

    return errors
