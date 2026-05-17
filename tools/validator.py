import os
import re
import sys

class IBMiValidator:
    def __init__(self, root_dir):
        self.root_dir = root_dir
        self.errors = []

    def log_error(self, file_path, message):
        self.errors.append(f"[ERROR] {file_path}: {message}")

    def validate_naming(self):
        """Checks if files follow the layer naming convention."""
        rpg_dir = os.path.join(self.root_dir, 'qrpglesrc')
        if not os.path.exists(rpg_dir):
            return

        valid_suffixes = ['_repo.sqlrpgle', '_serv.rpgle', '_main.rpgle', '_h.rpgleinc']
        for filename in os.listdir(rpg_dir):
            if filename.startswith('t_'): # Tests are allowed
                continue
            
            if not any(filename.endswith(suffix) for suffix in valid_suffixes):
                self.log_error(filename, "Invalid naming convention. Must end with _repo, _serv, _main, or _h.")

    def validate_sql_standards(self, file_path):
        """Checks for Forbidden SQL patterns like SELECT *."""
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read().upper()
            if 'SELECT *' in content:
                self.log_error(file_path, "Forbidden 'SELECT *' detected.")
            
            # Check for parameterization (basic check for host variables)
            if 'SELECT' in content and 'FROM' in content:
                if "WHERE" in content and ":" not in content and "?" not in content:
                   if "JOIN" not in content: # Simple heuristic
                        self.log_error(file_path, "Possible non-parameterized SQL detected.")

    def validate_rpg_free(self, file_path):
        """Checks if RPG file is free-format."""
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            first_line = f.readline().strip().upper()
            if first_line.startswith('     '): # Typical fixed format start
                self.log_error(file_path, "Fixed-format RPG detected. Must be Free-format.")

    def run(self):
        print(f"--- Starting Validation in {self.root_dir} ---")
        self.validate_naming()
        
        for root, _, files in os.walk(self.root_dir):
            for file in files:
                path = os.path.join(root, file)
                if file.endswith(('.rpgle', '.sqlrpgle')):
                    self.validate_sql_standards(path)
                    self.validate_rpg_free(path)
                if file.endswith('.sql'):
                    self.validate_sql_standards(path)

        if self.errors:
            for err in self.errors:
                print(err)
            return False
        
        print("--- Validation Successful! ---")
        return True

if __name__ == "__main__":
    validator = IBMiValidator('.')
    success = validator.run()
    if not success:
        sys.exit(1)
