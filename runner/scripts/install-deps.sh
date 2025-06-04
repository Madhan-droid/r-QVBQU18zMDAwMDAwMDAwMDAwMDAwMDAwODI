#!/bin/bash

ROOT="node_modules/.pnpm"
STACK_PREFIX="@cny-cdk-stack+"
CNY_NAMESPACE="@cny-cdk-stack"
LAMBDA_SRC_DEPTH=4
LAMBDA_SRC_PATTERN="*/lambda/*/src"
NPMRC_RENAMED=".npmrc.txt"
NPMRC_ORIGINAL=".npmrc"

echo "🔍 Searching for lambda/*/src folders in ${STACK_PREFIX}* packages..."

find "$ROOT" -type d -name "${STACK_PREFIX}*" | while read -r stackDir; do
  cnyModulePath="$stackDir/node_modules/$CNY_NAMESPACE"

  if [ -d "$cnyModulePath" ]; then
    find "$cnyModulePath" -mindepth "$LAMBDA_SRC_DEPTH" -maxdepth "$LAMBDA_SRC_DEPTH" -type d -path "$LAMBDA_SRC_PATTERN" | while read -r srcDir; do
      echo "📁 Found lambda src directory: $srcDir"

      bash -c "
        echo '📦 Installing pnpm if not already installed...' &&
        command -v pnpm || { echo '⚠️ pnpm not found, installing...'; npm install -g pnpm; } &&
        echo '📍 Entering $srcDir' &&
        cd \"$srcDir\" &&
        ([ -f $NPMRC_RENAMED ] && mv $NPMRC_RENAMED $NPMRC_ORIGINAL || echo 'ℹ️ $NPMRC_RENAMED not found') &&
        echo '📥 Running pnpm install...' &&
        pnpm install || { echo '❌ pnpm install failed in $srcDir'; exit 1; }
      "
    done
  else
    echo "❌ Directory not found: $cnyModulePath"
  fi
done
