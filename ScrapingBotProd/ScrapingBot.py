from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import pickle
import pprint

link = open("link.txt")
lines = link.readlines()

PATH = "chromedriver.exe"
driver = webdriver.Chrome(PATH)
driver.get(lines[0])

time.sleep(60)
while True:
    if len(lines) == 2:
        specify = WebDriverWait(driver, 2).until(
            EC.presence_of_element_located((By.ID, lines[1]))
        )
        specify.click()
        time.sleep(2)
    try:
        element = WebDriverWait(driver, 2).until(
            EC.presence_of_element_located((By.ID, "add-to-cart-button"))
        )
        element.click()
        time.sleep(2)
        break
    except:
        driver.refresh()
        time.sleep(2)

link.close()

try:
    navcart = driver.find_element_by_css_selector(
        "#attach-sidesheet-checkout-button > span > input"
    )
    navcart.click()
except:
    navcart = driver.find_element_by_id("nav-cart")
    navcart.click()
    proceed = driver.find_element_by_id("sc-buy-box-ptc-button")
    proceed.click()

buy = driver.find_element_by_css_selector("#bottomSubmitOrderButtonId > span > input")
buy.click()

driver.quit()