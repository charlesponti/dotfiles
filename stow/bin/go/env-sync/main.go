package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

// EnvFile represents a parsed .env file
type EnvFile struct {
	Path      string
	Variables map[string]string
	Relative  string // relative path for display
}

// EnvManager handles multiple .env files
type EnvManager struct {
	Files    []*EnvFile
	RootPath string
}

// ParseEnvFile reads and parses an .env file
func ParseEnvFile(filePath string) (*EnvFile, error) {
	content, err := os.ReadFile(filePath)
	if err != nil {
		return nil, err
	}

	env := &EnvFile{
		Path:      filePath,
		Variables: make(map[string]string),
	}

	scanner := bufio.NewScanner(strings.NewReader(string(content)))
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())

		// Skip empty lines and comments
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		// Parse KEY=VALUE
		parts := strings.SplitN(line, "=", 2)
		if len(parts) == 2 {
			key := strings.TrimSpace(parts[0])
			value := strings.TrimSpace(parts[1])
			env.Variables[key] = value
		}
	}

	return env, scanner.Err()
}

// NewEnvManager creates a manager and scans for .env files
func NewEnvManager(rootPath string) (*EnvManager, error) {
	manager := &EnvManager{
		RootPath: rootPath,
		Files:    []*EnvFile{},
	}

	// Walk directory and find all .env files
	err := filepath.Walk(rootPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if !info.IsDir() && (strings.HasPrefix(info.Name(), ".env") && !strings.HasSuffix(info.Name(), ".example")) {
			envFile, err := ParseEnvFile(path)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Warning: Failed to parse %s: %v\n", path, err)
				return nil
			}
			rel, _ := filepath.Rel(rootPath, path)
			envFile.Relative = rel
			manager.Files = append(manager.Files, envFile)
		}

		return nil
	})

	// Sort files for consistent output
	sort.Slice(manager.Files, func(i, j int) bool {
		return manager.Files[i].Relative < manager.Files[j].Relative
	})

	return manager, err
}

// AllVariables returns all unique variable keys across all files
func (em *EnvManager) AllVariables() []string {
	vars := make(map[string]bool)
	for _, file := range em.Files {
		for key := range file.Variables {
			vars[key] = true
		}
	}

	keys := make([]string, 0, len(vars))
	for key := range vars {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	return keys
}

// CheckInconsistencies finds variables with different values
func (em *EnvManager) CheckInconsistencies() map[string]map[string][]string {
	inconsistencies := make(map[string]map[string][]string)

	for _, varName := range em.AllVariables() {
		valueMap := make(map[string][]string)

		for _, file := range em.Files {
			value, exists := file.Variables[varName]
			if !exists {
				value = "(missing)"
			}
			valueMap[value] = append(valueMap[value], file.Relative)
		}

		// Only include if there are multiple different values
		if len(valueMap) > 1 {
			inconsistencies[varName] = valueMap
		}
	}

	return inconsistencies
}

// PrintStatus shows current state
func (em *EnvManager) PrintStatus() {
	fmt.Printf("📁 Scanning: %s\n", em.RootPath)
	fmt.Printf("📄 Found %d env files:\n", len(em.Files))

	for _, file := range em.Files {
		fmt.Printf("   ✓ %s (%d variables)\n", file.Relative, len(file.Variables))
	}

	inconsistencies := em.CheckInconsistencies()

	if len(inconsistencies) == 0 {
		fmt.Printf("\n✅ All env files are in sync!\n")
		return
	}

	fmt.Printf("\n⚠️  Found %d inconsistencies:\n\n", len(inconsistencies))

	for varName := range inconsistencies {
		keys := make([]string, 0, len(inconsistencies[varName]))
		for k := range inconsistencies[varName] {
			keys = append(keys, k)
		}
		sort.Strings(keys)
	}

	// Print sorted inconsistencies
	sortedVars := make([]string, 0, len(inconsistencies))
	for varName := range inconsistencies {
		sortedVars = append(sortedVars, varName)
	}
	sort.Strings(sortedVars)

	for _, varName := range sortedVars {
		valueMap := inconsistencies[varName]
		fmt.Printf("📌 %s:\n", varName)

		// Sort values for consistent output
		values := make([]string, 0, len(valueMap))
		for v := range valueMap {
			values = append(values, v)
		}
		sort.Strings(values)

		for _, value := range values {
			files := valueMap[value]
			sort.Strings(files)

			if value == "(missing)" {
				fmt.Printf("   ❌ (missing): %s\n", strings.Join(files, ", "))
			} else {
				indicator := "✓"
				if len(files) < len(em.Files) {
					indicator = "⚠️"
				}
				fmt.Printf("   %s %q in: %s\n", indicator, value, strings.Join(files, ", "))
			}
		}
		fmt.Println()
	}
}

// DiffFiles shows differences between two specific files
func (em *EnvManager) DiffFiles(filePath1, filePath2 string) error {
	var file1, file2 *EnvFile

	for _, f := range em.Files {
		if strings.Contains(f.Relative, filePath1) {
			file1 = f
		}
		if strings.Contains(f.Relative, filePath2) {
			file2 = f
		}
	}

	if file1 == nil || file2 == nil {
		return fmt.Errorf("one or both files not found")
	}

	allVars := make(map[string]bool)
	for k := range file1.Variables {
		allVars[k] = true
	}
	for k := range file2.Variables {
		allVars[k] = true
	}

	vars := make([]string, 0, len(allVars))
	for v := range allVars {
		vars = append(vars, v)
	}
	sort.Strings(vars)

	fmt.Printf("📊 Comparing:\n  %s\n  %s\n\n", file1.Relative, file2.Relative)

	hasDiffs := false
	for _, varName := range vars {
		val1, exists1 := file1.Variables[varName]
		val2, exists2 := file2.Variables[varName]

		if val1 != val2 {
			hasDiffs = true
			fmt.Printf("📌 %s:\n", varName)

			if !exists1 {
				fmt.Printf("   [1] (missing)\n")
			} else {
				fmt.Printf("   [1] %q\n", val1)
			}

			if !exists2 {
				fmt.Printf("   [2] (missing)\n")
			} else {
				fmt.Printf("   [2] %q\n", val2)
			}
			fmt.Println()
		}
	}

	if !hasDiffs {
		fmt.Println("✅ Files are identical!")
	}

	return nil
}

// ValidateAgainstTemplate checks files have all template variables
func (em *EnvManager) ValidateAgainstTemplate(templatePath string) error {
	template, err := ParseEnvFile(templatePath)
	if err != nil {
		return err
	}

	fmt.Printf("📋 Validating against template: %s\n", templatePath)
	fmt.Printf("   Template has %d variables\n\n", len(template.Variables))

	hasErrors := false

	for _, file := range em.Files {
		missing := []string{}
		extra := []string{}

		for varName := range template.Variables {
			if _, exists := file.Variables[varName]; !exists {
				missing = append(missing, varName)
			}
		}

		for varName := range file.Variables {
			if _, exists := template.Variables[varName]; !exists {
				extra = append(extra, varName)
			}
		}

		if len(missing) > 0 || len(extra) > 0 {
			hasErrors = true
			fmt.Printf("❌ %s\n", file.Relative)

			if len(missing) > 0 {
				sort.Strings(missing)
				fmt.Printf("   Missing: %s\n", strings.Join(missing, ", "))
			}

			if len(extra) > 0 {
				sort.Strings(extra)
				fmt.Printf("   Extra: %s\n", strings.Join(extra, ", "))
			}
		} else {
			fmt.Printf("✅ %s\n", file.Relative)
		}
	}

	if !hasErrors {
		fmt.Println("\n✅ All files match template!")
	}

	return nil
}

func main() {
	statusCmd := flag.NewFlagSet("status", flag.ExitOnError)
	diffCmd := flag.NewFlagSet("diff", flag.ExitOnError)
	validateCmd := flag.NewFlagSet("validate", flag.ExitOnError)

	validateTemplate := validateCmd.String("template", ".env.example", "Template file to validate against")

	if len(os.Args) < 2 {
		printHelp()
		os.Exit(0)
	}

	rootPath := "."

	// Try to determine root path (look for multiple .env files)
	switch os.Args[1] {
	case "status":
		statusCmd.Parse(os.Args[2:])
		if len(statusCmd.Args()) > 0 {
			rootPath = statusCmd.Args()[0]
		}

		manager, err := NewEnvManager(rootPath)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

		if len(manager.Files) == 0 {
			fmt.Fprintf(os.Stderr, "Error: No .env files found in %s\n", rootPath)
			os.Exit(1)
		}

		manager.PrintStatus()

	case "diff":
		diffCmd.Parse(os.Args[2:])
		args := diffCmd.Args()

		if len(args) < 2 {
			fmt.Fprintf(os.Stderr, "Error: diff requires two file paths\n")
			fmt.Fprintf(os.Stderr, "Usage: env-sync diff <path1> <path2> [root-path]\n")
			os.Exit(1)
		}

		if len(args) > 2 {
			rootPath = args[2]
		}

		manager, err := NewEnvManager(rootPath)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

		if err := manager.DiffFiles(args[0], args[1]); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

	case "validate":
		validateCmd.Parse(os.Args[2:])
		args := validateCmd.Args()

		if len(args) > 0 {
			rootPath = args[0]
		}

		manager, err := NewEnvManager(rootPath)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

		templatePath := filepath.Join(rootPath, *validateTemplate)
		if err := manager.ValidateAgainstTemplate(templatePath); err != nil {
			fmt.Fprintf(os.Stderr, "Error reading template: %v\n", err)
			os.Exit(1)
		}

	case "help", "-help", "-h":
		printHelp()

	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n", os.Args[1])
		fmt.Fprintf(os.Stderr, "Use 'env-sync help' for usage information\n")
		os.Exit(1)
	}
}

func printHelp() {
	fmt.Println(`Env Sync - Keep your monorepo .env files in sync

Usage:
  env-sync <command> [options] [root-path]

Commands:
  status              Show status of all .env files and inconsistencies
  diff <path1> <path2> Show differences between two .env files
  validate            Check all files match the template
  help                Show this help message

Examples:
  env-sync status
  env-sync status /path/to/monorepo
  env-sync diff apps/backend apps/frontend
  env-sync validate
  env-sync validate -template .env.example /path/to/monorepo

Options:
  -template string    Template file to validate (default: .env.example)

Features:
  - Scans recursively for .env, .env.local, .env.test files
  - Detects variables with different values across files
  - Shows which files are missing variables
  - Compares two specific files
  - Validates against a template
`)
}
