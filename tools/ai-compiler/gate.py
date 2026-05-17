def run_gate(filename, code):
    errors = []

    # Rule #9: OUTPUT FORMAT STANDARD
    required_sections = [
        "1. Analysis",
        "2. Proposed structure",
        "3. Code",
        "4. DB2 notes",
        "5. Risk assessment"
    ]

    for section in required_sections:
        if section not in code:
            errors.append(f"Gate Error: Missing mandatory section: {section}")

    # Basic IBM i syntax check (simulation)
    if "**free" not in code.lower():
         # Every modern RPGLE file should start with **FREE or at least have it
         # But sometimes it's implied by the compiler. We'll check for it as a safety measure.
         errors.append("Gate Error: Missing '**FREE' directive for free-format RPGLE.")

    return errors
