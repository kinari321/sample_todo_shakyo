package main

import (
	"fmt"
	// "log"
	"sample_todo_shakyo/app/models"
	"sample_todo_shakyo/app/controllers"
)

func main() {
	fmt.Println(models.Db)

	controllers.StartMainServer()

}
