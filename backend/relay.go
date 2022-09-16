package main

import (
	"github.com/zfz7/relay_go/backend/repository"
	"github.com/zfz7/relay_go/backend/server"
)

func main() {
	repository.StartDB()
	server.StartWebServer()
}
