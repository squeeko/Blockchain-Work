import { Inter } from "next/font/google";
import "bootstrap-icons/font/bootstrap-icons.css";
import "./style.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Blockchain Explorer",
  description: "Explore the Ethereum Blockchain",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  );
}
