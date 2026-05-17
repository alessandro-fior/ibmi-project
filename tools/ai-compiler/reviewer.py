from agent_hub import gemini_review, codex_review, claude_review
from voter import calculate_verdict

def run_pr_review(code):
    print("\n--- MULTI-AGENT PR REVIEW START ---")
    
    # Dispatch to agents
    reviews = [
        gemini_review(code),
        codex_review(code),
        claude_review(code)
    ]
    
    # Calculate final verdict
    result = calculate_verdict(reviews)
    
    # Print report
    print(f"FINAL VERDICT: {result['verdict']} (Score: {result['score']})")
    print("-" * 35)
    
    for detail in result['details']:
        print(f"Agent: {detail['agent']} | Status: {detail['status']} | Vote: {detail['vote']}")
        for comment in detail['comments']:
            print(f"  - {comment}")
        print("-" * 10)
        
    return result

if __name__ == "__main__":
    # Example usage for manual CLI check
    test_code = """
**FREE
dcl-proc sample_serv;
  exec sql SELECT * FROM users;
end-proc;
"""
    run_pr_review(test_code)
