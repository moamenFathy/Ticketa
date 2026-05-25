import { motion } from "framer-motion";
import { Crown, Tag, Zap } from "lucide-react";

const AdvantagesSection = () => {
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.5, duration: 0.6 }}
      className="relative z-20 flex items-center gap-8"
    >
      {[
        {
          icon: Zap,
          label: "Fast Booking",
          color: "text-amber-500",
          bgColor: "bg-amber-500/10",
          borderColor: "border-amber-500/20",
          hoverBg: "group-hover/item:bg-amber-500/20",
          hoverBorder: "group-hover/item:border-amber-500/30",
        },
        {
          icon: Tag,
          label: "Exclusive Offers",
          color: "text-emerald-500",
          bgColor: "bg-emerald-500/10",
          borderColor: "border-emerald-500/20",
          hoverBg: "group-hover/item:bg-emerald-500/20",
          hoverBorder: "group-hover/item:border-emerald-500/30",
        },
        {
          icon: Crown,
          label: "Premium Rewards",
          color: "text-primary",
          bgColor: "bg-primary/10",
          borderColor: "border-primary/20",
          hoverBg: "group-hover/item:bg-primary/20",
          hoverBorder: "group-hover/item:border-primary/30",
        },
      ].map((item, i) => (
        <div
          key={i}
          className="flex items-center gap-2.5 group/item cursor-default"
        >
          <div
            className={`h-10 w-10 rounded-xl ${item.bgColor} border ${item.borderColor} ${item.hoverBg} ${item.hoverBorder} flex items-center justify-center group-hover/item:scale-110 group-hover/item:-translate-y-1 group-hover/item:rotate-3 transition-all duration-300 shadow-sm`}
          >
            <item.icon
              className={`h-5 w-5 ${item.color} drop-shadow-[0_0_8px_rgba(var(--color-primary),0.2)]`}
            />
          </div>
          <span className="text-muted-foreground dark:text-zinc-500 text-[10px] font-bold uppercase tracking-widest group-hover/item:text-foreground dark:group-hover/item:text-zinc-300 transition-colors">
            {item.label}
          </span>
        </div>
      ))}
    </motion.div>
  );
};

export default AdvantagesSection;
