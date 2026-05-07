import { useParams } from "react-router-dom";

const MovieDetails = () => {
  const { id } = useParams();
  return <div>MovieDetails: {id}</div>;
};

export default MovieDetails;
