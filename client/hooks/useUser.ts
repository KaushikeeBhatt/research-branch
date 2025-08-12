import { useRouter } from "next/router";
import { useEffect, useState } from "react";

const useUser = () => {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [userId, setUserId] = useState<number | null>(null);
  const [user, setUser] = useState<any>(null);

  useEffect(() => {
    const token = localStorage.getItem("token");
    const storedId = localStorage.getItem("id");
    const storedUser = localStorage.getItem("user");

    if (!token) {
      // No token, redirect to sign in
      router.push("/auth/sign-in");
    } else {
      setUserId(storedId ? parseInt(storedId) : null);
      setUser(storedUser ? JSON.parse(storedUser) : null);
    }
    
    setLoading(false);
  }, [router]);

  const logout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("id");
    localStorage.removeItem("user");
    router.push("/auth/sign-in");
  };

  return {
    userId,
    user,
    loading,
    logout,
  };
};

export default useUser;