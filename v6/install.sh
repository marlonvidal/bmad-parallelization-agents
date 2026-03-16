#!/usr/bin/env bash

################################################################################
# BMAD Parallel Agents — v6 Installation Script
#
# Installs parallel Frontend/Backend workflow overrides into any BMAD v6 project.
# Targets the bmad-create-epics-and-stories workflow step files so that every
# story generation session automatically produces paired BE/FE stories instead
# of vertical slices.
#
# Version: 1.0
# Compatible with: BMAD v6.x
#
# Usage:
#   bash <(curl -fsSL "https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/v6/install.sh?$(date +%s)")
#
# Or download and run locally:
#   curl -O https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/v6/install.sh
#   chmod +x install.sh
#   ./install.sh
################################################################################

set -e  # Exit on error

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Raw URL base for this distribution
RAW_REPO_URL="https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/v6/workflows"

# Target path inside a BMAD v6 project (relative to project root)
WORKFLOW_TARGET="_bmad/bmm/workflows/3-solutioning/bmad-create-epics-and-stories"

# Files to download and their sub-paths within the workflow target
declare -A WORKFLOW_FILES=(
    ["steps/step-02-design-epics.md"]="steps/step-02-design-epics.md"
    ["steps/step-03-create-stories.md"]="steps/step-03-create-stories.md"
    ["templates/epics-template.md"]="templates/epics-template.md"
)

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}  BMAD Parallel Agents Installer — v6${NC}"
    echo -e "${BLUE}  Compatible with BMAD v6.x${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error()   { echo -e "${RED}✗ $1${NC}"; }
print_info()    { echo -e "${YELLOW}ℹ $1${NC}"; }
print_step()    { echo -e "${BLUE}→ $1${NC}"; }

################################################################################
# Main Installation Logic
################################################################################

main() {
    print_header

    # Step 1: Verify this is a BMAD v6 project
    print_step "Step 1: Verifying BMAD v6 installation..."

    if [ ! -d "_bmad/bmm/workflows" ]; then
        print_error "BMAD v6 not detected — '_bmad/bmm/workflows/' directory not found."
        echo ""
        echo "This installer requires a BMAD v6 project."
        echo "Please run it from the root of a project where BMAD v6 is already installed."
        echo "Install BMAD v6 first: https://docs.bmad-method.org/how-to/install-bmad"
        exit 1
    fi
    print_success "BMAD v6 detected: _bmad/bmm/workflows/ found"

    if [ ! -d "${WORKFLOW_TARGET}/steps" ]; then
        print_error "bmad-create-epics-and-stories workflow not found at: ${WORKFLOW_TARGET}/steps"
        echo "Please ensure the BMad Method module (bmm) is installed."
        exit 1
    fi
    print_success "bmad-create-epics-and-stories workflow found"
    echo ""

    # Step 2: Check for curl or wget
    print_step "Step 2: Checking download tools..."

    DOWNLOAD_CMD=""
    if command -v curl &> /dev/null; then
        DOWNLOAD_CMD="curl"
        print_success "Found curl"
    elif command -v wget &> /dev/null; then
        DOWNLOAD_CMD="wget"
        print_success "Found wget"
    else
        print_error "Neither curl nor wget found. Please install one of them."
        exit 1
    fi
    echo ""

    # Step 3: Back up existing workflow files
    print_step "Step 3: Backing up existing workflow files..."

    BACKUP_DIR="${WORKFLOW_TARGET}/.backup-$(date +%Y%m%d-%H%M%S)"
    BACKUP_CREATED=false

    for src_path in "${!WORKFLOW_FILES[@]}"; do
        TARGET_FILE="${WORKFLOW_TARGET}/${src_path}"
        if [ -f "$TARGET_FILE" ]; then
            if [ "$BACKUP_CREATED" = false ]; then
                mkdir -p "${BACKUP_DIR}/steps" "${BACKUP_DIR}/templates"
                BACKUP_CREATED=true
                print_info "Created backup directory: $BACKUP_DIR"
            fi
            cp "$TARGET_FILE" "${BACKUP_DIR}/${src_path}"
            print_info "Backed up: ${src_path}"
        fi
    done

    if [ "$BACKUP_CREATED" = false ]; then
        print_info "No existing files to backup"
    else
        print_success "Backup complete"
    fi
    echo ""

    # Step 4: Download and install workflow overrides
    print_step "Step 4: Downloading and installing parallel workflow overrides..."

    DOWNLOAD_FAILED=false

    for src_path in "${!WORKFLOW_FILES[@]}"; do
        FILE_URL="${RAW_REPO_URL}/${src_path}"
        TARGET_FILE="${WORKFLOW_TARGET}/${src_path}"

        print_info "Downloading: ${src_path}..."

        if [ "$DOWNLOAD_CMD" = "curl" ]; then
            if curl -fsSL "$FILE_URL" -o "$TARGET_FILE"; then
                print_success "Installed: ${src_path}"
            else
                print_error "Failed to download: ${src_path}"
                DOWNLOAD_FAILED=true
            fi
        elif [ "$DOWNLOAD_CMD" = "wget" ]; then
            if wget -q "$FILE_URL" -O "$TARGET_FILE"; then
                print_success "Installed: ${src_path}"
            else
                print_error "Failed to download: ${src_path}"
                DOWNLOAD_FAILED=true
            fi
        fi
    done
    echo ""

    # Step 5: Summary
    print_step "Installation Summary"
    echo ""

    if [ "$DOWNLOAD_FAILED" = true ]; then
        print_error "Some files failed to download. Please check the URLs and try again."
        if [ "$BACKUP_CREATED" = true ]; then
            print_info "Your originals are safe at: $BACKUP_DIR"
        fi
        exit 1
    fi

    print_success "All parallel workflow overrides installed successfully!"
    echo ""
    print_info "Installation location: ${WORKFLOW_TARGET}"
    if [ "$BACKUP_CREATED" = true ]; then
        print_info "Backup location: ${BACKUP_DIR}"
    fi

    echo ""
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}================================================${NC}"
    echo ""
    echo "Files installed into: ${WORKFLOW_TARGET}/"
    echo "  • steps/step-02-design-epics.md   — epics now classified by Implementation Domain"
    echo "  • steps/step-03-create-stories.md — Full-Stack epics generate paired BE/FE stories"
    echo "  • templates/epics-template.md     — story blocks include parallel delivery fields"
    echo ""
    echo "What changes in your workflow:"
    echo "  • Step 2 (Design Epics): each epic gets an Implementation Domain tag"
    echo "    Full-Stack | Backend-Only | Frontend-Only | Non-Technical"
    echo "  • Step 3 (Create Stories): Full-Stack epics automatically produce paired stories:"
    echo "    Story N.M-BE (API + DB, defines Data Contract)"
    echo "    Story N.M-FE (UI/UX using mocked contract — no BE dependency)"
    echo "  • No vertical-slice stories for Full-Stack features"
    echo ""
    echo "To revert to originals, restore from: ${BACKUP_DIR}"
    echo ""
}

main "$@"
