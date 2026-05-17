from validator import run_skill_validator

def gemini_review(code):
    """Gemini: The primary guardian of GEMINI.md standards."""
    errors = run_skill_validator(code)
    # Gemini is strict on every standard error
    status = "REJECT" if errors else "APPROVE"
    return {
        "agent": "Gemini",
        "status": status,
        "vote": 1 if status == "APPROVE" else -1,
        "comments": errors if errors else ["Code complies with all IBM i 7.5 standards."]
    }

def codex_review(code):
    """Codex: Focused on algorithmic efficiency and complexity."""
    errors = run_skill_validator(code)
    # Codex also cares about efficiency (simulated check)
    comments = [e for e in errors]
    
    if code.count("for") > 3: # Simple simulation of complexity check
         comments.append("Performance Note: High loop nesting detected. Consider optimization.")
    
    # Codex is stricter on complexity
    status = "REJECT" if any("SQL Error" in e for e in errors) or "Performance Note" in "".join(comments) else "APPROVE"
    return {
        "agent": "Codex",
        "status": status,
        "vote": 1 if status == "APPROVE" else -1,
        "comments": comments if comments else ["Logic looks efficient."]
    }

def claude_review(code):
    """Claude: Focused on documentation, risk, and readability."""
    errors = run_skill_validator(code)
    comments = [e for e in errors]
    
    # Claude checks for documentation sections (Rule #9)
    is_missing_doc = False
    if "1. Analysis" not in code:
        comments.append("Documentation Note: Missing Analysis section.")
        is_missing_doc = True
        
    # Claude rejects if standards are violated OR if doc is missing
    status = "REJECT" if errors or is_missing_doc else "APPROVE"
    return {
        "agent": "Claude",
        "status": status,
        "vote": 1 if status == "APPROVE" else -1,
        "comments": comments if comments else ["Documentation is comprehensive."]
    }
