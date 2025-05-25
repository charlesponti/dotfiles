package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
)

// Config holds all the configuration for generating web icons
type Config struct {
	Input           string
	OutputDir       string
	SiteName        string
	SiteURL         string
	ThemeColor      string
	BackgroundColor string
}

// IconSize represents an icon size configuration
type IconSize struct {
	Size     string
	Filename string
}

// ManifestIcon represents an icon in the web manifest
type ManifestIcon struct {
	Src     string `json:"src"`
	Sizes   string `json:"sizes"`
	Type    string `json:"type"`
	Purpose string `json:"purpose"`
}

// WebManifest represents the PWA manifest structure
type WebManifest struct {
	Name            string         `json:"name"`
	ShortName       string         `json:"short_name"`
	Description     string         `json:"description"`
	StartURL        string         `json:"start_url"`
	Display         string         `json:"display"`
	Orientation     string         `json:"orientation"`
	BackgroundColor string         `json:"background_color"`
	ThemeColor      string         `json:"theme_color"`
	Icons           []ManifestIcon `json:"icons"`
}

// BrowserConfig represents the browserconfig.xml structure
type BrowserConfig struct {
	MSApplication MSApplication `xml:"msapplication"`
}

type MSApplication struct {
	Tile Tile `xml:"tile"`
}

type Tile struct {
	Square70x70Logo   string `xml:"square70x70logo,attr"`
	Square150x150Logo string `xml:"square150x150logo,attr"`
	Square310x310Logo string `xml:"square310x310logo,attr"`
	TileColor         string `xml:"TileColor"`
}

func main() {
	config := parseFlags()

	if err := validateConfig(config); err != nil {
		fmt.Printf("❌ Error: %v\n", err)
		os.Exit(1)
	}

	printConfig(config)

	if err := checkImageMagick(); err != nil {
		fmt.Printf("❌ %v\n", err)
		os.Exit(1)
	}

	if err := generateIcons(config); err != nil {
		fmt.Printf("❌ Error generating icons: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("✅ All icons generated successfully!")
	printSummary(config)
}

func parseFlags() *Config {
	config := &Config{}

	flag.StringVar(&config.Input, "i", "", "Input image file (required)")
	flag.StringVar(&config.Input, "input", "", "Input image file (required)")
	flag.StringVar(&config.OutputDir, "o", "icons", "Output directory")
	flag.StringVar(&config.OutputDir, "output", "icons", "Output directory")
	flag.StringVar(&config.SiteName, "n", "My Website", "Site name for manifest")
	flag.StringVar(&config.SiteName, "name", "My Website", "Site name for manifest")
	flag.StringVar(&config.SiteURL, "u", "/", "Site URL for manifest")
	flag.StringVar(&config.SiteURL, "url", "/", "Site URL for manifest")
	flag.StringVar(&config.ThemeColor, "t", "#ffffff", "Theme color in hex")
	flag.StringVar(&config.ThemeColor, "theme", "#ffffff", "Theme color in hex")
	flag.StringVar(&config.BackgroundColor, "b", "#ffffff", "Background color in hex")
	flag.StringVar(&config.BackgroundColor, "background", "#ffffff", "Background color in hex")

	showHelp := flag.Bool("h", false, "Show help message")
	flag.BoolVar(showHelp, "help", false, "Show help message")

	flag.Usage = func() {
		fmt.Print(`Usage: webicon-maker -i <input> [options]

Generate web icons and PWA assets from a source image.

OPTIONS:
  -i, --input <file>        Input image file (required)
  -o, --output <dir>        Output directory (default: icons)
  -n, --name <name>         Site name for manifest (default: "My Website")
  -u, --url <url>           Site URL for manifest (default: "/")
  -t, --theme <color>       Theme color in hex (default: "#ffffff")
  -b, --background <color>  Background color in hex (default: "#ffffff")
  -h, --help               Show this help message

EXAMPLES:
  webicon-maker -i logo.png
  webicon-maker -i logo.png -o assets/icons -n "My App" -u "https://example.com"
  webicon-maker --input logo.svg --output icons --theme "#4285f4" --background "#ffffff"

GENERATED FILES:
  - favicon.ico and various favicon PNGs
  - Apple Touch icons in various sizes
  - Android/PWA icons in various sizes
  - Microsoft Tile icons
  - Social media sharing images (og-image.jpg, twitter-card.jpg)
  - manifest.json for PWAs
  - link-tags.html with HTML tags to include in your page
  - browserconfig.xml for Microsoft browsers
`)
	}

	flag.Parse()

	if *showHelp {
		flag.Usage()
		os.Exit(0)
	}

	return config
}

func validateConfig(config *Config) error {
	if config.Input == "" {
		return fmt.Errorf("input image file is required")
	}

	if _, err := os.Stat(config.Input); os.IsNotExist(err) {
		return fmt.Errorf("input file '%s' does not exist", config.Input)
	}

	if err := validateHexColor(config.ThemeColor, "theme"); err != nil {
		return err
	}

	if err := validateHexColor(config.BackgroundColor, "background"); err != nil {
		return err
	}

	return nil
}

func validateHexColor(color, name string) error {
	matched, _ := regexp.MatchString(`^#[0-9A-Fa-f]{6}$`, color)
	if !matched {
		return fmt.Errorf("invalid %s color '%s'. Please use hex format like #ffffff", name, color)
	}
	return nil
}

func printConfig(config *Config) {
	fmt.Println("🎨 Web Icon Maker")
	fmt.Printf("📂 Input: %s\n", config.Input)
	fmt.Printf("📁 Output: %s\n", config.OutputDir)
	fmt.Printf("🏷️  Site: %s\n", config.SiteName)
	fmt.Printf("🌐 URL: %s\n", config.SiteURL)
	fmt.Printf("🎨 Theme: %s\n", config.ThemeColor)
	fmt.Printf("🎨 Background: %s\n", config.BackgroundColor)
	fmt.Println()
}

func checkImageMagick() error {
	fmt.Println("🔍 Checking for ImageMagick...")
	if _, err := exec.LookPath("magick"); err != nil {
		return fmt.Errorf("ImageMagick not found. Please install it first:\n   brew install imagemagick")
	}
	return nil
}

func generateIcons(config *Config) error {
	// Create output directory
	if err := os.MkdirAll(config.OutputDir, 0755); err != nil {
		return fmt.Errorf("failed to create output directory: %v", err)
	}
	fmt.Printf("📁 Creating output directory: %s\n", config.OutputDir)

	// Generate favicon.ico
	fmt.Println("🔄 Generating favicon.ico...")
	if err := runMagick(config.Input, "-define", "icon:auto-resize=16,32,48,64,128,256", filepath.Join(config.OutputDir, "favicon.ico")); err != nil {
		return fmt.Errorf("failed to generate favicon.ico: %v", err)
	}

	// Generate standard favicon PNGs
	fmt.Println("🔄 Generating standard favicon PNGs...")
	faviconSizes := []IconSize{
		{"16x16", "favicon-16x16.png"},
		{"32x32", "favicon-32x32.png"},
		{"48x48", "favicon-48x48.png"},
		{"96x96", "favicon-96x96.png"},
	}
	if err := generateIconSet(config, faviconSizes); err != nil {
		return err
	}

	// Generate Apple touch icons
	fmt.Println("🔄 Generating Apple touch icons...")
	appleSizes := []IconSize{
		{"57x57", "apple-touch-icon-57x57.png"},
		{"60x60", "apple-touch-icon-60x60.png"},
		{"72x72", "apple-touch-icon-72x72.png"},
		{"76x76", "apple-touch-icon-76x76.png"},
		{"114x114", "apple-touch-icon-114x114.png"},
		{"120x120", "apple-touch-icon-120x120.png"},
		{"144x144", "apple-touch-icon-144x144.png"},
		{"152x152", "apple-touch-icon-152x152.png"},
		{"180x180", "apple-touch-icon.png"},
		{"180x180", "apple-touch-icon-180x180.png"},
	}
	if err := generateIconSet(config, appleSizes); err != nil {
		return err
	}

	// Generate Android & PWA icons
	fmt.Println("🔄 Generating Android & PWA icons...")
	androidSizes := []IconSize{
		{"36x36", "android-icon-36x36.png"},
		{"48x48", "android-icon-48x48.png"},
		{"72x72", "android-icon-72x72.png"},
		{"96x96", "android-icon-96x96.png"},
		{"144x144", "android-icon-144x144.png"},
		{"192x192", "android-icon-192x192.png"},
		{"192x192", "icon-192x192.png"},
		{"384x384", "icon-384x384.png"},
		{"512x512", "icon-512x512.png"},
	}
	if err := generateIconSet(config, androidSizes); err != nil {
		return err
	}

	// Generate Microsoft Tile icons
	fmt.Println("🔄 Generating Microsoft Tile icons...")
	msSizes := []IconSize{
		{"70x70", "ms-icon-70x70.png"},
		{"144x144", "ms-icon-144x144.png"},
		{"150x150", "ms-icon-150x150.png"},
		{"310x310", "ms-icon-310x310.png"},
	}
	if err := generateIconSet(config, msSizes); err != nil {
		return err
	}

	// Generate Social Media sharing icons
	fmt.Println("🔄 Generating Social Media sharing icons...")
	if err := runMagick(config.Input, "-resize", "1200x630", filepath.Join(config.OutputDir, "og-image.jpg")); err != nil {
		return fmt.Errorf("failed to generate og-image.jpg: %v", err)
	}
	if err := runMagick(config.Input, "-resize", "1200x600", filepath.Join(config.OutputDir, "twitter-card.jpg")); err != nil {
		return fmt.Errorf("failed to generate twitter-card.jpg: %v", err)
	}

	// Generate manifest.json
	fmt.Println("📝 Generating manifest.json...")
	if err := generateManifest(config); err != nil {
		return err
	}

	// Generate link-tags.html
	fmt.Println("📝 Generating link-tags.html...")
	if err := generateLinkTags(config); err != nil {
		return err
	}

	// Generate browserconfig.xml
	fmt.Println("📝 Generating browserconfig.xml...")
	if err := generateBrowserConfig(config); err != nil {
		return err
	}

	fmt.Println("⚠️  Note: For Safari Pinned Tab, a monochrome SVG is recommended.")
	fmt.Printf("   If you have an SVG source, manually copy it to %s/safari-pinned-tab.svg\n", config.OutputDir)

	return nil
}

func generateIconSet(config *Config, sizes []IconSize) error {
	for _, size := range sizes {
		outputPath := filepath.Join(config.OutputDir, size.Filename)
		if err := runMagick(config.Input, "-resize", size.Size, outputPath); err != nil {
			return fmt.Errorf("failed to generate %s: %v", size.Filename, err)
		}
	}
	return nil
}

func runMagick(args ...string) error {
	cmd := exec.Command("magick", args...)
	return cmd.Run()
}

func generateManifest(config *Config) error {
	manifest := WebManifest{
		Name:            config.SiteName,
		ShortName:       config.SiteName,
		Description:     config.SiteName + " - Web Application",
		StartURL:        "/",
		Display:         "standalone",
		Orientation:     "any",
		BackgroundColor: config.BackgroundColor,
		ThemeColor:      config.ThemeColor,
		Icons: []ManifestIcon{
			{
				Src:     "./icon-192x192.png",
				Sizes:   "192x192",
				Type:    "image/png",
				Purpose: "any maskable",
			},
			{
				Src:     "./icon-384x384.png",
				Sizes:   "384x384",
				Type:    "image/png",
				Purpose: "any maskable",
			},
			{
				Src:     "./icon-512x512.png",
				Sizes:   "512x512",
				Type:    "image/png",
				Purpose: "any maskable",
			},
		},
	}

	data, err := json.MarshalIndent(manifest, "", "  ")
	if err != nil {
		return fmt.Errorf("failed to marshal manifest: %v", err)
	}

	manifestPath := filepath.Join(config.OutputDir, "manifest.json")
	return os.WriteFile(manifestPath, data, 0644)
}

func generateLinkTags(config *Config) error {
	content := fmt.Sprintf(`<!-- Favicon -->
<link rel="icon" type="image/x-icon" href="%s/favicon.ico">
<link rel="icon" type="image/png" sizes="16x16" href="%s/favicon-16x16.png">
<link rel="icon" type="image/png" sizes="32x32" href="%s/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="96x96" href="%s/favicon-96x96.png">

<!-- Apple Touch Icons -->
<link rel="apple-touch-icon" href="%s/apple-touch-icon.png">
<link rel="apple-touch-icon" sizes="57x57" href="%s/apple-touch-icon-57x57.png">
<link rel="apple-touch-icon" sizes="60x60" href="%s/apple-touch-icon-60x60.png">
<link rel="apple-touch-icon" sizes="72x72" href="%s/apple-touch-icon-72x72.png">
<link rel="apple-touch-icon" sizes="76x76" href="%s/apple-touch-icon-76x76.png">
<link rel="apple-touch-icon" sizes="114x114" href="%s/apple-touch-icon-114x114.png">
<link rel="apple-touch-icon" sizes="120x120" href="%s/apple-touch-icon-120x120.png">
<link rel="apple-touch-icon" sizes="144x144" href="%s/apple-touch-icon-144x144.png">
<link rel="apple-touch-icon" sizes="152x152" href="%s/apple-touch-icon-152x152.png">
<link rel="apple-touch-icon" sizes="180x180" href="%s/apple-touch-icon-180x180.png">

<!-- Android Icons -->
<link rel="icon" type="image/png" sizes="36x36" href="%s/android-icon-36x36.png">
<link rel="icon" type="image/png" sizes="48x48" href="%s/android-icon-48x48.png">
<link rel="icon" type="image/png" sizes="72x72" href="%s/android-icon-72x72.png">
<link rel="icon" type="image/png" sizes="96x96" href="%s/android-icon-96x96.png">
<link rel="icon" type="image/png" sizes="144x144" href="%s/android-icon-144x144.png">
<link rel="icon" type="image/png" sizes="192x192" href="%s/android-icon-192x192.png">

<!-- Microsoft Tile Icons -->
<meta name="msapplication-TileColor" content="%s">
<meta name="msapplication-TileImage" content="%s/ms-icon-144x144.png">
<meta name="msapplication-square70x70logo" content="%s/ms-icon-70x70.png">
<meta name="msapplication-square150x150logo" content="%s/ms-icon-150x150.png">
<meta name="msapplication-square310x310logo" content="%s/ms-icon-310x310.png">

<!-- Web Manifest -->
<link rel="manifest" href="%s/manifest.json">

<!-- Theme Color -->
<meta name="theme-color" content="%s">

<!-- Safari Pinned Tab Icon -->
<link rel="mask-icon" href="%s/safari-pinned-tab.svg" color="%s">

<!-- Social Media / OpenGraph -->
<meta property="og:image" content="%s/%s/og-image.jpg">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="%s/%s/twitter-card.jpg">`,
		config.OutputDir, config.OutputDir, config.OutputDir, config.OutputDir,
		config.OutputDir, config.OutputDir, config.OutputDir, config.OutputDir,
		config.OutputDir, config.OutputDir, config.OutputDir, config.OutputDir,
		config.OutputDir, config.OutputDir, config.OutputDir, config.OutputDir,
		config.OutputDir, config.OutputDir, config.OutputDir, config.OutputDir,
		config.ThemeColor, config.OutputDir, config.OutputDir, config.OutputDir,
		config.OutputDir, config.OutputDir, config.ThemeColor, config.OutputDir,
		config.ThemeColor, config.SiteURL, config.OutputDir, config.SiteURL, config.OutputDir)

	linkTagsPath := filepath.Join(config.OutputDir, "link-tags.html")
	return os.WriteFile(linkTagsPath, []byte(content), 0644)
}

func generateBrowserConfig(config *Config) error {
	content := fmt.Sprintf(`<?xml version="1.0" encoding="utf-8"?>
<browserconfig>
  <msapplication>
    <tile>
      <square70x70logo src="%s/ms-icon-70x70.png"/>
      <square150x150logo src="%s/ms-icon-150x150.png"/>
      <square310x310logo src="%s/ms-icon-310x310.png"/>
      <TileColor>%s</TileColor>
    </tile>
  </msapplication>
</browserconfig>`,
		config.OutputDir, config.OutputDir, config.OutputDir, config.ThemeColor)

	browserConfigPath := filepath.Join(config.OutputDir, "browserconfig.xml")
	return os.WriteFile(browserConfigPath, []byte(content), 0644)
}

func printSummary(config *Config) {
	fmt.Println()
	fmt.Printf("📄 Generated files in '%s/':\n", config.OutputDir)
	fmt.Println("   • favicon.ico and various favicon PNGs")
	fmt.Println("   • Apple Touch icons in various sizes")
	fmt.Println("   • Android/PWA icons in various sizes")
	fmt.Println("   • Microsoft Tile icons")
	fmt.Println("   • Social media sharing images (og-image.jpg, twitter-card.jpg)")
	fmt.Println("   • manifest.json for PWAs")
	fmt.Println("   • link-tags.html with HTML tags to include in your page")
	fmt.Println("   • browserconfig.xml for Microsoft browsers")
	fmt.Println()
	fmt.Println("📋 Next steps:")
	fmt.Printf("   1. Copy the contents of '%s/link-tags.html' into your HTML <head> section\n", config.OutputDir)
	fmt.Println("   2. Adjust the paths as needed for your project structure")
	fmt.Println("   3. Copy the icon files to your web server's public directory")
	fmt.Println()
	fmt.Println("💡 Tip: Run 'webicon-maker --help' for more options")
}
