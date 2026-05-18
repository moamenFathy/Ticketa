export const CATEGORY_COLORS: Record<
  string,
  { bg: string; border: string; text: string; glow: string; label: string }
> = {
  Standard: {
    bg: "bg-blue-500/20 hover:bg-blue-500/50",
    border: "border-blue-500/40 hover:border-blue-400",
    text: "text-blue-600 dark:text-blue-300",
    glow: "shadow-blue-500/30",
    label: "Standard",
  },
  Premium: {
    bg: "bg-violet-500/20 hover:bg-violet-500/50",
    border: "border-violet-500/40 hover:border-violet-400",
    text: "text-violet-600 dark:text-violet-300",
    glow: "shadow-violet-500/30",
    label: "Premium",
  },
  VIP: {
    bg: "bg-amber-500/20 hover:bg-amber-500/50",
    border: "border-amber-500/40 hover:border-amber-400",
    text: "text-amber-600 dark:text-amber-300",
    glow: "shadow-amber-500/30",
    label: "VIP",
  },
  Gold: {
    bg: "bg-yellow-500/20 hover:bg-yellow-500/50",
    border: "border-yellow-500/40 hover:border-yellow-400",
    text: "text-yellow-600 dark:text-yellow-300",
    glow: "shadow-yellow-500/30",
    label: "Gold",
  },
  IMAX: {
    bg: "bg-cyan-500/20 hover:bg-cyan-500/50",
    border: "border-cyan-500/40 hover:border-cyan-400",
    text: "text-cyan-600 dark:text-cyan-300",
    glow: "shadow-cyan-500/30",
    label: "IMAX",
  },
  Default: {
    bg: "bg-slate-500/20 hover:bg-slate-500/50",
    border: "border-slate-500/40 hover:border-slate-400",
    text: "text-slate-600 dark:text-slate-300",
    glow: "shadow-slate-500/30",
    label: "Standard",
  },
};