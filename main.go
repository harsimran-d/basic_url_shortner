package main

import (
	"fmt"
	"math/rand"

	"net/http"

	"github.com/gin-gonic/gin"
)

var shorts = map[string]string{}

func main() {
	router := gin.Default()

	router.GET("/:short", redirectHandler)
	router.POST("/shorten", shortenUrl)
	router.Run("localhost:3000")
}

func redirectHandler(c *gin.Context) {
	short := c.Param("short")
	link, found := shorts[short]
	if found {
		c.Redirect(http.StatusTemporaryRedirect, link)
		return
	}
	c.Status(http.StatusNotFound)
}
func shortenUrl(c *gin.Context) {
	var destination string
	if err := c.BindJSON(&destination); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "destination URL cannot be empty"})
		return
	}
	key := ""
	for {
		key = getRandomKey()
		if _, exists := shorts[key]; !exists {
			break
		}
	}
	shorts[key] = destination
	fmt.Println(key)
	c.JSON(http.StatusCreated, map[string]string{"short": ("http://localhost:3000/" + key)})
}

func getRandomKey() string {
	random7Alphabets := ""
	for range 7 {
		random7Alphabets += string(rand.Intn(26) + 97)
	}
	return random7Alphabets
}
