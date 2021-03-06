package main

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
)

const (
	host     = "db"
	port     = 5432
	user     = "postgres"
	password = "password"
	dbname   = "junction21"
)
func dbConnect(dbInfo string) *sql.DB{
	db, err := sql.Open("postgres", dbInfo)
	if err != nil {
		panic(err)
	}
	return  db
}
func dbQueryHandler(db *sql.DB, query string){
	_, err := db.Exec(query)
	if err != nil{
		fmt.Println(query)
		panic(err)
	}
}
func main() {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s sslmode=disable",
		host, port, user, password)
	db := dbConnect(psqlInfo)

	query := "DROP DATABASE IF EXISTS "+ dbname
	dbQueryHandler(db, query)

	query = "CREATE DATABASE "+ dbname
	dbQueryHandler(db, query)
	db.Close()


	psqlInfo = fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)
	db = dbConnect(psqlInfo)


	query  = "CREATE TABLE IF NOT EXISTS users ( " +
		"id integer GENERATED ALWAYS AS IDENTITY, " +
		"name varchar(32) UNIQUE, " +
		"xp integer, " +
		"PRIMARY KEY(id))"
	dbQueryHandler(db, query)

	query = "CREATE TABLE IF NOT EXISTS tasks ( " +
		"id integer GENERATED ALWAYS AS IDENTITY, " +
		"user_id integer, " +
		"name varchar(128), " +
		"xp integer, " +
		"description varchar(1024), " +
		"start_date date, " +
		"end_date date, " +
		"PRIMARY KEY(id), " +
		"CONSTRAINT fk_users FOREIGN KEY(user_id) REFERENCES users(id))"

	dbQueryHandler(db, query)
	db.Close()
	fmt.Println("Successfully connected!")
}