import { Star, Clock, Calendar, Globe } from "lucide-react";
import { motion } from "framer-motion";

interface MovieStatsProps {
  rating: number;
  runtime: number;
  releaseDate: string;
  language: string;
}

export const MovieStats = ({
  rating,
  runtime,
  releaseDate,
  language,
}: MovieStatsProps) => {
  const formatRuntime = (minutes: number) => {
    const h = Math.floor(minutes / 60);
    const m = minutes % 60;
    return `${h}h ${m}m`;
  };

  const stats = [
    {
      icon: Star,
      value: rating.toFixed(1),
      label: "IMDB",
      color: "text-primary",
    },
    {
      icon: Clock,
      value: formatRuntime(runtime),
      label: "Runtime",
      color: "text-primary",
    },
    {
      icon: Calendar,
      value: new Date(releaseDate).getFullYear(),
      label: "Release",
      color: "text-primary",
    },
    {
      icon: Globe,
      value: language.toUpperCase(),
      label: "Language",
      color: "text-primary",
    },
  ];

  return (
    <div className="flex flex-wrap gap-4 mt-8">
      {stats.map((stat, i) => (
        <motion.div
          key={i}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: i * 0.1 }}
          className="bg-black/5 dark:bg-white/5 backdrop-blur-xl border border-black/10 dark:border-white/10 px-6 py-4 rounded-3xl flex items-center gap-4 group hover:bg-black/10 dark:hover:bg-white/10 transition-colors cursor-default"
        >
          <div
            className={`p-3 rounded-2xl bg-black/5 dark:bg-white/5 group-hover:scale-110 transition-transform ${stat.color}`}
          >
            <stat.icon className="w-5 h-5" />
          </div>
          <div>
            <p className="text-[10px] uppercase font-bold text-black/40 dark:text-white/30 tracking-widest">
              {stat.label}
            </p>
            <p className="font-bold text-lg text-black dark:text-white leading-tight">
              {stat.value}
            </p>
          </div>
        </motion.div>
      ))}
    </div>
  );
};
