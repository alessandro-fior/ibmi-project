import os
import sys

def run_pipeline():
    print(">>> Running IBM i Modernization Pipeline")
    
    # 1. Run Validator
    print("\n[1/2] Running Standards Validator...")
    exit_code = os.system("python tools/validator.py")
    
    if exit_code != 0:
        print("\n[!] Validation Failed. Please fix the errors above.")
        sys.exit(1)
    
    # 2. Mocking future steps (e.g., analyzer, refactor)
    print("\n[2/2] Standards check passed. System ready for analysis.")
    print("\n>>> Pipeline Completed Successfully.")

if __name__ == "__main__":
    run_pipeline()
