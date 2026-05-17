def calculate_verdict(reviews):
    """
    Calculates the final PR verdict using a Weighted (Gemini Lead) strategy.
    
    Weights:
    - Gemini: 1.5
    - Codex: 1.0
    - Claude: 1.0
    
    Vote:
    - Approval: +1
    - Rejection: -1
    """
    total_score = 0.0
    
    for review in reviews:
        weight = 1.0
        if review['agent'] == "Gemini":
            weight = 1.5
            
        total_score += (review['vote'] * weight)
        
    final_status = "APPROVED" if total_score > 0 else "REJECTED"
    
    return {
        "score": total_score,
        "verdict": final_status,
        "details": reviews
    }
