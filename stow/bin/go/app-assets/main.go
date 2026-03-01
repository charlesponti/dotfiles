package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// AssetConfig defines the directory structure for each platform
type AssetConfig struct {
	Web     WebAssets
	Mobile  MobileAssets
	Desktop DesktopAssets
}

type WebAssets struct {
	Favicon []int // Common favicon sizes
	Icons   []int // Common web icon sizes
}

type MobileAssets struct {
	iOS     map[string]int // iOS asset sizes with names
	Android map[string]int // Android asset sizes with names
}

type DesktopAssets struct {
	macOS   []int
	Windows []int
	Linux   []int
}

func NewAssetConfig() AssetConfig {
	return AssetConfig{
		Web: WebAssets{
			Favicon: []int{16, 32, 64},
			Icons:   []int{128, 256, 512, 1024},
		},
		Mobile: MobileAssets{
			iOS: map[string]int{
				"icon-60x60":     60,
				"icon-120x120":   120,
				"icon-180x180":   180,
				"icon-40x40":     40,
				"icon-80x80":     80,
				"icon-152x152":   152,
				"icon-167x167":   167,
				"icon-1024x1024": 1024,
			},
			Android: map[string]int{
				"ldpi":              36,
				"mdpi":              48,
				"hdpi":              72,
				"xhdpi":             96,
				"xxhdpi":            144,
				"xxxhdpi":           192,
				"xxxhdpi-playstore": 512,
			},
		},
		Desktop: DesktopAssets{
			macOS:   []int{16, 32, 64, 128, 256, 512, 1024},
			Windows: []int{16, 32, 64, 128, 256},
			Linux:   []int{16, 32, 48, 64, 128, 256},
		},
	}
}

func createDirectory(path string) error {
	return os.MkdirAll(path, 0755)
}

func checkImageMagick() error {
	cmd := exec.Command("which", "magick")
	return cmd.Run()
}

func resizeImage(inputFile, outputFile string, size int, format string) error {
	sizeStr := fmt.Sprintf("%dx%d", size, size)
	args := []string{inputFile, "-resize", sizeStr, "-gravity", "center", "-extent", sizeStr, outputFile}

	cmd := exec.Command("magick", args...)
	if output, err := cmd.CombinedOutput(); err != nil {
		return fmt.Errorf("failed to resize image: %v\n%s", err, string(output))
	}
	return nil
}

func processWebAssets(imageFile, basePath string, config AssetConfig) error {
	if imageFile == "" {
		return nil
	}

	fmt.Println("📊 Processing web assets...")

	// Process favicons
	faviconDir := filepath.Join(basePath, "web", "favicon")
	for _, size := range config.Web.Favicon {
		outputFile := filepath.Join(faviconDir, fmt.Sprintf("favicon-%dx%d.png", size, size))
		if err := resizeImage(imageFile, outputFile, size, "png"); err != nil {
			return fmt.Errorf("favicon %dx%d: %v", size, size, err)
		}
		fmt.Printf("  ✓ favicon-%dx%d.png\n", size, size)
	}

	// Process web icons
	iconsDir := filepath.Join(basePath, "web", "icons")
	for _, size := range config.Web.Icons {
		outputFile := filepath.Join(iconsDir, fmt.Sprintf("icon-%dx%d.png", size, size))
		if err := resizeImage(imageFile, outputFile, size, "png"); err != nil {
			return fmt.Errorf("icon %dx%d: %v", size, size, err)
		}
		fmt.Printf("  ✓ icon-%dx%d.png\n", size, size)
	}

	return nil
}

func processMobileAssets(imageFile, basePath string, config AssetConfig) error {
	if imageFile == "" {
		return nil
	}

	fmt.Println("📱 Processing mobile assets...")

	// Process iOS assets
	iosDir := filepath.Join(basePath, "mobile", "ios")
	for name, size := range config.Mobile.iOS {
		outputFile := filepath.Join(iosDir, fmt.Sprintf("%s.png", name))
		if err := resizeImage(imageFile, outputFile, size, "png"); err != nil {
			return fmt.Errorf("iOS %s: %v", name, err)
		}
		fmt.Printf("  ✓ %s.png (%dx%d)\n", name, size, size)
	}

	// Process Android assets
	androidDir := filepath.Join(basePath, "mobile", "android")
	for name, size := range config.Mobile.Android {
		outputFile := filepath.Join(androidDir, fmt.Sprintf("%s.png", name))
		if err := resizeImage(imageFile, outputFile, size, "png"); err != nil {
			return fmt.Errorf("Android %s: %v", name, err)
		}
		fmt.Printf("  ✓ %s.png (%dx%d)\n", name, size, size)
	}

	return nil
}

func processDesktopAssets(imageFile, basePath string, config AssetConfig) error {
	if imageFile == "" {
		return nil
	}

	fmt.Println("🖥️  Processing desktop assets...")

	// macOS assets
	macosDir := filepath.Join(basePath, "desktop", "macos")
	for _, size := range config.Desktop.macOS {
		outputFile := filepath.Join(macosDir, fmt.Sprintf("icon-%dx%d.png", size, size))
		if err := resizeImage(imageFile, outputFile, size, "png"); err != nil {
			return fmt.Errorf("macOS %dx%d: %v", size, size, err)
		}
		fmt.Printf("  ✓ icon-%dx%d.png (macOS)\n", size, size)
	}

	// Windows assets (need to generate both PNG and ICO)
	windowsDir := filepath.Join(basePath, "desktop", "windows")
	for _, size := range config.Desktop.Windows {
		pngFile := filepath.Join(windowsDir, fmt.Sprintf("icon-%dx%d.png", size, size))
		icoFile := filepath.Join(windowsDir, fmt.Sprintf("icon-%dx%d.ico", size, size))

		// Create PNG first
		if err := resizeImage(imageFile, pngFile, size, "png"); err != nil {
			return fmt.Errorf("Windows PNG %dx%d: %v", size, size, err)
		}

		// Convert to ICO
		cmd := exec.Command("magick", pngFile, icoFile)
		if output, err := cmd.CombinedOutput(); err != nil {
			return fmt.Errorf("Windows ICO %dx%d: %v\n%s", size, size, err, string(output))
		}

		// Clean up PNG (optional, comment out if you want to keep both)
		os.Remove(pngFile)
		fmt.Printf("  ✓ icon-%dx%d.ico (Windows)\n", size, size)
	}

	// Linux assets
	linuxDir := filepath.Join(basePath, "desktop", "linux")
	for _, size := range config.Desktop.Linux {
		outputFile := filepath.Join(linuxDir, fmt.Sprintf("icon-%dx%d.png", size, size))
		if err := resizeImage(imageFile, outputFile, size, "png"); err != nil {
			return fmt.Errorf("Linux %dx%d: %v", size, size, err)
		}
		fmt.Printf("  ✓ icon-%dx%d.png (Linux)\n", size, size)
	}

	return nil
}

func getAllDirectories(config AssetConfig, basePath string) []string {
	var dirs []string

	// Web directories
	dirs = append(dirs, filepath.Join(basePath, "web", "favicon"))
	dirs = append(dirs, filepath.Join(basePath, "web", "icons"))

	// Mobile directories
	dirs = append(dirs, filepath.Join(basePath, "mobile", "ios"))
	dirs = append(dirs, filepath.Join(basePath, "mobile", "android"))

	// Desktop directories
	dirs = append(dirs, filepath.Join(basePath, "desktop", "macos"))
	dirs = append(dirs, filepath.Join(basePath, "desktop", "windows"))
	dirs = append(dirs, filepath.Join(basePath, "desktop", "linux"))

	return dirs
}

func generateAssetTree(config AssetConfig, basePath string) string {
	var output strings.Builder

	output.WriteString(fmt.Sprintf("%s/\n", basePath))

	output.WriteString("├── web/\n")
	output.WriteString("│   ├── favicon/\n")
	for _, size := range config.Web.Favicon {
		output.WriteString(fmt.Sprintf("│   │   └── favicon-%dx%d.png\n", size, size))
	}
	output.WriteString("│   └── icons/\n")
	for _, size := range config.Web.Icons {
		output.WriteString(fmt.Sprintf("│       └── icon-%dx%d.png\n", size, size))
	}

	output.WriteString("├── mobile/\n")
	output.WriteString("│   ├── ios/\n")
	iosIcons := config.Mobile.iOS
	iCount := 0
	for name := range iosIcons {
		iCount++
		var connector string
		if iCount < len(iosIcons) {
			connector = "│   │   ├── "
		} else {
			connector = "│   │   └── "
		}
		output.WriteString(fmt.Sprintf("%s%s.png\n", connector, name))
	}
	output.WriteString("│   └── android/\n")
	androidDensities := config.Mobile.Android
	aCount := 0
	for name := range androidDensities {
		aCount++
		var connector string
		if aCount < len(androidDensities) {
			connector = "│       ├── "
		} else {
			connector = "│       └── "
		}
		output.WriteString(fmt.Sprintf("%s%s.png\n", connector, name))
	}

	output.WriteString("└── desktop/\n")
	output.WriteString("    ├── macos/\n")
	for _, size := range config.Desktop.macOS {
		output.WriteString(fmt.Sprintf("    │   └── icon-%dx%d.png\n", size, size))
	}
	output.WriteString("    ├── windows/\n")
	for _, size := range config.Desktop.Windows {
		output.WriteString(fmt.Sprintf("    │   └── icon-%dx%d.ico\n", size, size))
	}
	output.WriteString("    └── linux/\n")
	for _, size := range config.Desktop.Linux {
		output.WriteString(fmt.Sprintf("        └── icon-%dx%d.png\n", size, size))
	}

	return output.String()
}

func main() {
	showHelp := flag.Bool("help", false, "Show help message")
	showTree := flag.Bool("tree", false, "Show directory tree without creating")
	imageFile := flag.String("image", "", "Input image file (PNG, JPG, etc.)")
	skipResize := flag.Bool("skip-resize", false, "Create directories but skip image resizing")

	flag.Parse()

	if *showHelp {
		fmt.Println(`App Assets Generator
Generates a directory structure for web, desktop, and mobile app assets.
Optionally resizes an image to all required dimensions.

Usage:
  app-assets [options] <output-directory>
  app-assets -tree [output-directory]

Options:
  -help              Show this help message
  -tree              Show directory tree structure (don't create directories)
  -image string      Input image file (PNG, JPG, etc.)
  -skip-resize       Create directories only, don't resize images

Examples:
  app-assets ./assets
  app-assets -tree ./assets
  app-assets -image logo.png ./assets
  app-assets -image logo.png -skip-resize ./assets

The generated structure includes:
  - web/favicon/      (16x16, 32x32, 64x64)
  - web/icons/        (128x128, 256x256, 512x512, 1024x1024)
  - mobile/ios/       (multiple sizes for iOS)
  - mobile/android/   (multiple densities for Android)
  - desktop/macos/    (multiple sizes for macOS)
  - desktop/windows/  (multiple sizes for Windows, .ico format)
  - desktop/linux/    (multiple sizes for Linux)

Requirements:
  - ImageMagick (magick command) for image resizing
`)
		os.Exit(0)
	}

	// Get output directory from arguments
	args := flag.Args()
	if len(args) == 0 {
		fmt.Fprintf(os.Stderr, "Error: output directory required\n")
		fmt.Fprintf(os.Stderr, "Usage: app-assets [options] <output-directory>\n")
		fmt.Fprintf(os.Stderr, "Use -help for more information\n")
		os.Exit(1)
	}

	outputDir := args[0]
	config := NewAssetConfig()

	// Show tree if requested
	if *showTree {
		tree := generateAssetTree(config, outputDir)
		fmt.Println(tree)
		return
	}

	// Verify image file if provided
	if *imageFile != "" {
		if _, err := os.Stat(*imageFile); err != nil {
			fmt.Fprintf(os.Stderr, "Error: image file not found: %s\n", *imageFile)
			os.Exit(1)
		}

		// Check ImageMagick is available if we need to resize
		if !*skipResize {
			if err := checkImageMagick(); err != nil {
				fmt.Fprintf(os.Stderr, "Error: ImageMagick not found. Install with: brew install imagemagick\n")
				os.Exit(1)
			}
		}
	}

	// Create all directories
	dirs := getAllDirectories(config, outputDir)
	created := 0
	failed := 0

	for _, dir := range dirs {
		if err := createDirectory(dir); err != nil {
			fmt.Fprintf(os.Stderr, "Error creating directory %s: %v\n", dir, err)
			failed++
		} else {
			created++
		}
	}

	// Print summary
	tree := generateAssetTree(config, outputDir)
	fmt.Println(tree)
	fmt.Printf("\n✓ Created %d directories\n", created)

	if failed > 0 {
		fmt.Printf("✗ Failed to create %d directories\n", failed)
		os.Exit(1)
	}

	// Process images if provided and not skipped
	if *imageFile != "" && !*skipResize {
		fmt.Printf("\n🎨 Processing images from: %s\n\n", *imageFile)

		if err := processWebAssets(*imageFile, outputDir, config); err != nil {
			fmt.Fprintf(os.Stderr, "Error processing web assets: %v\n", err)
			os.Exit(1)
		}

		if err := processMobileAssets(*imageFile, outputDir, config); err != nil {
			fmt.Fprintf(os.Stderr, "Error processing mobile assets: %v\n", err)
			os.Exit(1)
		}

		if err := processDesktopAssets(*imageFile, outputDir, config); err != nil {
			fmt.Fprintf(os.Stderr, "Error processing desktop assets: %v\n", err)
			os.Exit(1)
		}

		fmt.Println("\n✓ All assets processed successfully!")
	}
}
