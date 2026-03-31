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
# Auto-detected in main() — two known BMAD v6 layouts are supported:
#   Layout A (no workflows/ layer): _bmad/bmm/3-solutioning/...
#   Layout B (with workflows/ layer): _bmad/bmm/workflows/3-solutioning/...
WORKFLOW_TARGET=""

# Files to download — sub-paths relative to WORKFLOW_TARGET (and to RAW_REPO_URL)
declare -a WORKFLOW_FILES=(
    "steps/step-02-design-epics.md"
    "steps/step-03-create-stories.md"
    "steps/step-04-final-validation.md"
    "templates/epics-template.md"
    "jira-utils.md"
)

# Documentation files placed at the workflow root (not inside steps/ or templates/)
# Source path is relative to RAW_REPO_URL parent (v6/)
declare -a DOC_FILES=(
    "JIRA-SETUP.md"
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

    if [ ! -d "_bmad" ]; then
        print_error "BMAD v6 not detected — '_bmad/' directory not found."
        echo ""
        echo "This installer requires a BMAD v6 project."
        echo "Please run it from the root of a project where BMAD v6 is already installed."
        echo "Install BMAD v6 first: https://docs.bmad-method.org/how-to/install-bmad"
        exit 1
    fi
    print_success "BMAD v6 detected: _bmad/ found"

    # Auto-detect the bmm layout — two known variants exist:
    #   Layout A: _bmad/bmm/3-solutioning/...          (no workflows/ layer)
    #   Layout B: _bmad/bmm/workflows/3-solutioning/... (with workflows/ layer)
    if [ -d "_bmad/bmm/workflows/3-solutioning" ]; then
        WORKFLOW_TARGET="_bmad/bmm/workflows/3-solutioning/bmad-create-epics-and-stories"
        print_success "Detected bmm layout: _bmad/bmm/workflows/3-solutioning/"
    elif [ -d "_bmad/bmm/3-solutioning" ]; then
        WORKFLOW_TARGET="_bmad/bmm/3-solutioning/bmad-create-epics-and-stories"
        print_success "Detected bmm layout: _bmad/bmm/3-solutioning/"
    else
        print_error "BMM solutioning phase not found."
        echo ""
        echo "Checked:"
        echo "  _bmad/bmm/workflows/3-solutioning/  (not found)"
        echo "  _bmad/bmm/3-solutioning/             (not found)"
        echo ""
        echo "This workflow is installed by the BMad Method module (bmm)."
        echo "Ensure the bmm module is installed in your BMAD v6 project, then re-run this installer."
        exit 1
    fi

    if [ ! -d "${WORKFLOW_TARGET}/steps" ]; then
        print_error "bmad-create-epics-and-stories workflow not found at: ${WORKFLOW_TARGET}/steps"
        echo ""
        echo "The bmm solutioning phase was found but the bmad-create-epics-and-stories workflow is missing."
        echo "Ensure the bmm module is fully installed, then re-run this installer."
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

    for src_path in "${WORKFLOW_FILES[@]}"; do
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

    for src_path in "${WORKFLOW_FILES[@]}"; do
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

    # Step 4b: Download and install documentation files (workflow root level)
    print_step "Step 4b: Downloading Jira integration documentation..."

    # DOC_FILES source is one level up from RAW_REPO_URL (v6/ root)
    DOC_RAW_URL="${RAW_REPO_URL%/workflows}"

    for doc_file in "${DOC_FILES[@]}"; do
        FILE_URL="${DOC_RAW_URL}/${doc_file}"
        TARGET_FILE="${WORKFLOW_TARGET}/${doc_file}"

        print_info "Downloading: ${doc_file}..."

        if [ "$DOWNLOAD_CMD" = "curl" ]; then
            if curl -fsSL "$FILE_URL" -o "$TARGET_FILE"; then
                print_success "Installed: ${doc_file}"
            else
                print_error "Failed to download: ${doc_file}"
                DOWNLOAD_FAILED=true
            fi
        elif [ "$DOWNLOAD_CMD" = "wget" ]; then
            if wget -q "$FILE_URL" -O "$TARGET_FILE"; then
                print_success "Installed: ${doc_file}"
            else
                print_error "Failed to download: ${doc_file}"
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
    echo "  • steps/step-02-design-epics.md      — epics now classified by Implementation Domain"
    echo "  • steps/step-03-create-stories.md    — Full-Stack epics generate paired BE/FE stories"
    echo "  • steps/step-04-final-validation.md  — validation + optional [J] Sync to Jira menu"
    echo "  • templates/epics-template.md        — story blocks include parallel delivery fields"
    echo "  • jira-utils.md                      — Jira MCP patterns reference"
    echo "  • JIRA-SETUP.md                      — one-time Jira setup guide"
    echo ""
    echo "What changes in your workflow:"
    echo "  • Step 2 (Design Epics): each epic gets an Implementation Domain tag"
    echo "    Full-Stack | Backend-Only | Frontend-Only | Non-Technical"
    echo "  • Step 3 (Create Stories): Full-Stack epics automatically produce paired stories:"
    echo "    Story N.M-BE (API + DB, defines Data Contract)"
    echo "    Story N.M-FE (UI/UX using mocked contract — no BE dependency)"
    echo "  • Step 4 (Final Validation): optional [J] Sync to Jira at the end"
    echo "  • No vertical-slice stories for Full-Stack features"
    echo ""
    echo "Optional Jira Integration:"
    echo "  Jira sync is disabled by default. To enable, follow the setup guide:"
    echo "  ${WORKFLOW_TARGET}/JIRA-SETUP.md"
    echo ""
    echo "To revert to originals, restore from: ${BACKUP_DIR}"
    echo ""
}

main "$@"
