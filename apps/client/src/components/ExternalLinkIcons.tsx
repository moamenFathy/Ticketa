import { motion } from "framer-motion";
import imdbLogo from "../../public/IMDb_Square_GoldBKG.svg";

interface ExternalLinkIconsProps {
  imdbId?: string;
  tmdbId?: number;
}

const ExternalLinkIcons = ({ imdbId, tmdbId }: ExternalLinkIconsProps) => {
  const platforms = [
    {
      id: "imdb",
      href: `https://www.imdb.com/title/${imdbId}/`,
      src: imdbLogo,
      alt: "IMDb",
      shadow: "hover:shadow-amber-400/20",
      show: !!imdbId,
    },
    {
      id: "tmdb",
      href: `https://www.themoviedb.org/movie/${tmdbId}`,
      src: "https://www.themoviedb.org/assets/2/v4/logos/v2/blue_square_2-d537fb228cf3ded904ef09b136fe3fec72548ebc1fea3fbbd1ad9e36364db38b.svg",
      alt: "TMDB",
      shadow: "hover:shadow-green-500/20",
      show: !!tmdbId,
    },
    {
      id: "letterboxd",
      href: `https://letterboxd.com/tmdb/${tmdbId}/`,
      src: "https://a.ltrbxd.com/logos/letterboxd-mac-icon.png",
      alt: "Letterboxd",
      shadow: "hover:shadow-emerald-600/20",
      show: !!tmdbId,
    },
  ].filter((p) => p.show);

  const itemVariants = {
    hidden: { opacity: 0, y: 10, scale: 0.96 },
    visible: { opacity: 1, y: 0, scale: 1, transition: { duration: 0.5 } },
  };

  return (
    <div className="space-y-4 pt-2">
      <span className="text-[10px] font-black uppercase tracking-[0.3em] text-black/40 dark:text-white/40">
        Share your rating and join the community on your preferred platforms
      </span>

      <motion.div
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true, margin: "-100px" }}
        variants={{
          hidden: {},
          visible: {
            transition: {
              staggerChildren: 0.15,
              delayChildren: 0.08,
            },
          },
        }}
        className="flex items-center gap-4"
      >
        {platforms.map((p) => (
          <motion.a
            key={p.id}
            href={p.href}
            target="_blank"
            rel="noopener noreferrer"
            title={`Open on ${p.alt}`}
            variants={itemVariants}
            whileHover={{ y: -4, scale: 1.08 }}
            whileTap={{ scale: 0.96 }}
            className={`p-3 rounded-2xl transition-shadow duration-300 hover:shadow-lg ${p.shadow}`}
          >
            <img src={p.src} alt={p.alt} className="w-8 h-8 object-contain" />
          </motion.a>
        ))}
      </motion.div>
    </div>
  );
};

export default ExternalLinkIcons;
