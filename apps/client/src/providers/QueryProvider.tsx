import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const reactQuery = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 1,
      staleTime: 1000 * 60 * 5, // 5 minutes
      refetchOnWindowFocus: false,
    },
  },
});

interface Props {
  children: React.ReactNode;
}

export default function QueryProvider({ children }: Props) {
  return (
    <QueryClientProvider client={reactQuery}>{children}</QueryClientProvider>
  );
}
