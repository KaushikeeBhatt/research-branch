import axios from "axios";

const Server = axios.create({
  baseURL: "http://127.0.0.1:4000",
});



// ✅ Add request interceptor to attach token
Server.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// ✅ Add response interceptor for auth errors
Server.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expired or invalid
      localStorage.removeItem("token");
      localStorage.removeItem("id");
      localStorage.removeItem("user");
      window.location.href = "/auth/sign-in";
    }
    return Promise.reject(error);
  }
);

Server.interceptors.response.use(
  (res) => res,
  (err) => {
    if (err.response.status === 401 || err.response.status === 403) {
      localStorage.removeItem("jwt");
      window.location.href = "/auth/sign-in";
    }

    return Promise.reject(err);
  }
);

export default Server;
