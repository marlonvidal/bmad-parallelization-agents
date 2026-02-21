#!/usr/bin/env bash

################################################################################
# BMAD Parallel Agents Installation Script
# 
# This script installs customized BMAD agents that support parallel 
# Frontend/Backend development into any target project.
#
# Usage:
#   bash <(curl -fsSL YOUR_RAW_URL/install-bmad-parallel.sh)
#
# Or download and run locally:
#   curl -O YOUR_RAW_URL/install-bmad-parallel.sh
#   chmod +x install-bmad-parallel.sh
#   ./install-bmad-parallel.sh
################################################################################

set -e  # Exit on error

# Color output for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
RAW_REPO_URL="https://raw.githubusercontent.com/marlonvidal/bmad-parallelization-agents/main/bmad-parallel-export"

# Agent files to download
declare -a AGENT_FILES=(
    "architect.md"
    "pm.md"
    "po.md"
    "developer-front.md"
    "developer-back.md"
)

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}  BMAD Parallel Agents Installer${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_step() {
    echo -e "${BLUE}→ $1${NC}"
}

################################################################################
# Main Installation Logic
################################################################################

main() {
    print_header
    
    # Step 1: Detect BMAD configuration directory
    print_step "Step 1: Detecting BMAD configuration..."
    
    BMAD_DIR=""
    
    if [ -d ".bmad-core/agents" ]; then
        BMAD_DIR=".bmad-core/agents"
        print_success "Found BMAD directory: .bmad-core/agents"
    elif [ -d ".bmad/agents" ]; then
        BMAD_DIR=".bmad/agents"
        print_success "Found BMAD directory: .bmad/agents"
    elif [ -d ".bmad-core" ]; then
        BMAD_DIR=".bmad-core/agents"
        print_info "Found .bmad-core but missing agents folder. Creating..."
        mkdir -p "$BMAD_DIR"
        print_success "Created directory: $BMAD_DIR"
    elif [ -d ".bmad" ]; then
        BMAD_DIR=".bmad/agents"
        print_info "Found .bmad but missing agents folder. Creating..."
        mkdir -p "$BMAD_DIR"
        print_success "Created directory: $BMAD_DIR"
    else
        print_info "No BMAD directory detected. Creating default structure..."
        BMAD_DIR=".bmad-core/agents"
        mkdir -p "$BMAD_DIR"
        print_success "Created directory: $BMAD_DIR"
    fi
    
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
    
    # Step 3: Backup existing agent files
    print_step "Step 3: Backing up existing agent files (if any)..."
    
    BACKUP_DIR="${BMAD_DIR}/.backup-$(date +%Y%m%d-%H%M%S)"
    BACKUP_CREATED=false
    
    for file in "${AGENT_FILES[@]}"; do
        if [ -f "${BMAD_DIR}/${file}" ]; then
            if [ "$BACKUP_CREATED" = false ]; then
                mkdir -p "$BACKUP_DIR"
                BACKUP_CREATED=true
                print_info "Created backup directory: $BACKUP_DIR"
            fi
            cp "${BMAD_DIR}/${file}" "${BACKUP_DIR}/${file}"
            print_info "Backed up: ${file}"
        fi
    done
    
    if [ "$BACKUP_CREATED" = false ]; then
        print_info "No existing agent files to backup"
    else
        print_success "Backup complete"
    fi
    
    echo ""
    
    # Step 4: Download and install custom agent files
    print_step "Step 4: Downloading and installing custom BMAD parallel agents..."
    
    DOWNLOAD_FAILED=false
    
    for file in "${AGENT_FILES[@]}"; do
        FILE_URL="${RAW_REPO_URL}/${file}"
        TARGET_PATH="${BMAD_DIR}/${file}"
        
        print_info "Downloading: ${file}..."
        
        if [ "$DOWNLOAD_CMD" = "curl" ]; then
            if curl -fsSL "$FILE_URL" -o "$TARGET_PATH"; then
                print_success "Installed: ${file}"
            else
                print_error "Failed to download: ${file}"
                DOWNLOAD_FAILED=true
            fi
        elif [ "$DOWNLOAD_CMD" = "wget" ]; then
            if wget -q "$FILE_URL" -O "$TARGET_PATH"; then
                print_success "Installed: ${file}"
            else
                print_error "Failed to download: ${file}"
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
        print_info "Backup location: $BACKUP_DIR"
        exit 1
    else
        print_success "All custom BMAD parallel agents installed successfully!"
        echo ""
        print_info "Installation location: ${BMAD_DIR}"
        
        if [ "$BACKUP_CREATED" = true ]; then
            print_info "Backup location: ${BACKUP_DIR}"
        fi
        
        echo ""
        echo -e "${GREEN}================================================${NC}"
        echo -e "${GREEN}  Installation Complete!${NC}"
        echo -e "${GREEN}================================================${NC}"
        echo ""
        echo "Your project now has the following custom agents:"
        echo "  • architect.md     - Holistic system architect with frontend/backend sharding"
        echo "  • pm.md            - Product manager with parallel story generation"
        echo "  • po.md            - Product owner with parallel story support"
        echo "  • developer-front.md - Frontend-only developer with contract-based mocks"
        echo "  • developer-back.md  - Backend-only developer with API-first approach"
        echo ""
        echo "These agents support parallel Frontend/Backend development!"
        echo ""
    fi
}

################################################################################
# Execute Main
################################################################################

main "$@"
