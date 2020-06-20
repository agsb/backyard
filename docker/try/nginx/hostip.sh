
docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"
docker inspect --format '{{.Config.Hostname}}' "$@"


