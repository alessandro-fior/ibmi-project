from gate import run_gate
from validator import run_skill_validator

def compile(spec, ai_generate_fn):

    print("AI COMPILER MODE START")

    # 1. GENERATE CODE
    code = ai_generate_fn(spec)

    # 2. SKILL VALIDATION
    skill_errors = run_skill_validator(code)

    if skill_errors:
        return {
            "status": "FAILED_SKILL_LAYER",
            "errors": skill_errors
        }

    # 3. OUTPUT GATE
    gate_errors = run_gate("generated.rpgle", code)

    if gate_errors:
        return {
            "status": "FAILED_OUTPUT_GATE",
            "errors": gate_errors,
            "retry": True
        }

    return {
        "status": "SUCCESS",
        "code": code
    }