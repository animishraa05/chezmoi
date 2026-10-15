#!/usr/bin/env bash
# Post-apply setup: the bits chezmoi cannot manage because they are
# generated, downloaded, or machine-specific.
#
# Runs once, after chezmoi has written the dotfiles.

set -euo pipefail

log() { echo "--> $*"; }

# --- 1. qutebrowser .env -----------------------------------------------------
# config.py reads .env via python-dotenv. It is gitignored on purpose: it
# holds machine-specific paths. Without it qutebrowser aborts with
# "Value was not recognized as a valid Boolean".
QUTE_ENV="$HOME/.config/qutebrowser/.env"

if [[ -f "$QUTE_ENV" ]]; then
    log "qutebrowser .env already present"
else
    cp "$HOME/.config/qutebrowser/.env.example" "$QUTE_ENV"
    log "created qutebrowser .env from .env.example"
    log ">>> EDIT IT: set SCREENSHORT_DIR, DOWNLOAD_DIR, GITHUB_USERNAME, HOMEPAGE"
fi

# --- 2. qutebrowser spellcheck dictionary ------------------------------------
# QtWebEngine wants .bdic dictionaries in qutebrowser's data dir. Fetching
# them over the network is unreliable, so source one from a Chromium app
# that ships it (vesktop, thorium, obsidian) and fall back to a download.
DICT_DIR="$HOME/.local/share/qutebrowser/qtwebengine_dictionaries"

if [[ -n "$(find "$DICT_DIR" -name 'en-*.bdic' 2>/dev/null)" ]]; then
    log "qutebrowser en-US dictionary already present"
else
    mkdir -p "$DICT_DIR"
    found=""
    for candidate in \
        "$HOME/.config/vesktop/sessionData/Dictionaries" \
        "$HOME/.config/thorium/Dictionaries" \
        "$HOME/.config/obsidian/Dictionaries"; do
        bdic=$(find "$candidate" -maxdepth 1 -name 'en-US*.bdic' 2>/dev/null | head -1)
        if [[ -n "$bdic" ]]; then
            cp "$bdic" "$DICT_DIR/"
            found=$(basename "$bdic")
            break
        fi
    done

    if [[ -n "$found" ]]; then
        log "installed qutebrowser dictionary from local Chromium app: $found"
    else
        log "no local .bdic found; qutebrowser will warn about a missing"
        log "dictionary for c.spellcheck.languages. Either install one of"
        log "vesktop/thorium, or remove c.spellcheck.languages from config.py."
    fi
fi

# --- 3. tmux plugins (TPM) --------------------------------------------------
# dot_tmux.conf declares @plugin entries; TPM itself is a separate clone.
TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ -d "$TPM_DIR" ]]; then
    log "TPM already installed"
else
    log "cloning tpm"
    git clone -q --depth 1 \
        https://github.com/tmux-plugins/tpm.git "$TPM_DIR"

    # Install everything declared in .tmux.conf.
    if [[ -f "$HOME/.tmux.conf" ]] && grep -q "@plugin" "$HOME/.tmux.conf"; then
        log "installing plugins declared in .tmux.conf"
        "$TPM_DIR/bin/install_plugins" || \
            log ">>> some plugins failed; run '$TPM_DIR/bin/install_plugins' later"
    fi
fi

# TPM needs a key binding to open its menu. ~/.tmux.conf is chezmoi-managed,
# so appending here would show up as drift on the next apply. Report instead.
if grep -q "prefix + I" "$HOME/.tmux.conf" 2>/dev/null; then
    log "TPM key binding already in .tmux.conf"
else
    log ">>> add this to ~/.tmux.conf to open the TPM plugin menu:"
    log ">>>     bind-prefix + I"
    log ">>>     run-shell $TPM_DIR"
fi

# --- 4. fish plugins --------------------------------------------------------
# fisher lives in ~/.config/fish/fish_plugins; conf.d carries fzf bindings.
if command -v fish >/dev/null && command -v fisher >/dev/null; then
    log "running fisher update"
    fish -c 'fisher update' || log ">>> fisher update reported errors"
else
    log "fisher not on PATH yet; run 'fish -c \"fisher update\"' after restarting your shell"
fi

log "post-apply setup finished"