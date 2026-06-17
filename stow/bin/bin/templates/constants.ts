/**
 * Template Constants
 *
 * Single source of truth for all template identifiers.
 * When updating a name, update it here and rebuild.
 *
 * All identifiers include the KERNEL_TEMPLATE_PREFIX and are defined with
 * full prefix as they appear in generated files.
 *
 * SKILL_NAMES: Complete skill identifiers (includes prefix)
 * AGENT_NAMES: Complete agent identifiers (includes prefix)
 * COMMAND_NAMES: Complete command identifiers (includes prefix)
 */

export const KERNEL_TEMPLATE_PREFIX = "kernel-";

export function prefixKernelTemplateName(name: string): string {
  return name.startsWith(KERNEL_TEMPLATE_PREFIX) ? name : `${KERNEL_TEMPLATE_PREFIX}${name}`;
}

// =============================================================================
// Skill Names (must include prefix as defined in skill templates)
// =============================================================================
export const SKILL_NAMES = {
  // Git skills
  GIT: prefixKernelTemplateName("git"),

  // Engineering skills
  PROJECT_SETUP: prefixKernelTemplateName("project-setup"),
  DOCS: prefixKernelTemplateName("docs"),
  PROJECT_INIT: prefixKernelTemplateName("project-init"),
  BUILD: prefixKernelTemplateName("build"),
  LOCATE: prefixKernelTemplateName("locate"),

  // Workflow skills
  APPLY: prefixKernelTemplateName("apply"),
  ARCHIVE: prefixKernelTemplateName("archive"),
  BOARD: prefixKernelTemplateName("board"),
  EXECUTE: prefixKernelTemplateName("execute"),
  INTAKE: prefixKernelTemplateName("intake"),
  PLAN: prefixKernelTemplateName("plan"),
  PROPOSE: prefixKernelTemplateName("propose"),
  INVESTIGATE: prefixKernelTemplateName("investigate"),
  REVIEW: prefixKernelTemplateName("review"),
  SHIP: prefixKernelTemplateName("ship"),
  STATUS: prefixKernelTemplateName("status"),
  SYNC: prefixKernelTemplateName("sync"),
  TRIAGE: prefixKernelTemplateName("triage"),
  UNBLOCK: prefixKernelTemplateName("unblock"),
  // Specialist skills
  API_ARCHITECTURE: prefixKernelTemplateName("api-architecture"),
  ASSET_INTEGRATION_SECURITY: prefixKernelTemplateName("asset-integration-security"),
  AUTH_CONTRACT: prefixKernelTemplateName("auth-contract"),
  DATABASE: prefixKernelTemplateName("database"),
  DOCKER: prefixKernelTemplateName("docker"),
  PDF: prefixKernelTemplateName("pdf"),
  REACT: prefixKernelTemplateName("react"),
  TESTING: prefixKernelTemplateName("testing"),
  TYPESCRIPT: prefixKernelTemplateName("typescript"),
  // Mobile skills
  REACT_NATIVE: prefixKernelTemplateName("react-native"),

  // Design skills
  DESIGN: prefixKernelTemplateName("design"),
  // Ecosystem skills
  SKILL_BUILDER: prefixKernelTemplateName("skill-builder"),
} as const;

export const AGENT_NAMES = {
  ARCHITECT: prefixKernelTemplateName("architect"),
  CAPTURE: prefixKernelTemplateName("capture"),
  DESIGNER: prefixKernelTemplateName("designer"),
  DO: prefixKernelTemplateName("do"),
  GIT: prefixKernelTemplateName("git"),
  PLAN: prefixKernelTemplateName("plan"),
  REVIEW: prefixKernelTemplateName("review"),
  SEARCH: prefixKernelTemplateName("search"),
} as const;

export const COMMAND_NAMES = {
  SYNC: prefixKernelTemplateName("sync"),
  DOCTOR: prefixKernelTemplateName("doctor"),
  GH_PR_ERRORS: prefixKernelTemplateName("gh-pr-errors"),
  GOAL_DONE: prefixKernelTemplateName("goal-done"),
  TASK_DONE: prefixKernelTemplateName("task-done"),
  TASK_STATUS: prefixKernelTemplateName("task-status"),
} as const;
