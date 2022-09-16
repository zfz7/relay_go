package repository

import (
	"fmt"
	"github.com/zfz7/relay_go/backend/helpers"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type MetaData struct {
	gorm.Model
	UserCount int
}

var dsn string

func StartDB() {
	var host = helpers.GetEnv("POSTGRES_HOST", "localhost")
	var port = helpers.GetEnv("POSTGRES_PORT", "5434")
	var user = helpers.GetEnv("POSTGRES_USER", "relay")
	var password = helpers.GetEnv("POSTGRES_PASSWORD", "relay")
	var dbname = helpers.GetEnv("POSTGRES_DB", "relay")

	dsn = fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s",
		host, user, password, dbname, port)

	Database, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}
	Database.AutoMigrate(&MetaData{})
}

func GetDB() (*gorm.DB, error) {
	return gorm.Open(postgres.Open(dsn), &gorm.Config{})
}
