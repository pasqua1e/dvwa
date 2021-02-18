#!/usr/bin/python3.7
import sys,time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

if len(sys.argv) < 2:
    print("Usage: "+sys.argv[0]+" [host] [port]")
    sys.exit()


options = Options()
#options.headless = True
options.add_argument("--window-size=1920,1200")
options.add_argument('--no-sandbox')
options.add_argument("--incognito")
options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36")


host="http://" + sys.argv[1] + ":" + sys.argv[2]
DRIVER_PATH='/usr/local/share/chromedriver'
driver = webdriver.Chrome(options=options, executable_path=DRIVER_PATH)
driver.get(host+"/login.php")
#print(driver.page_source)
username = driver.find_element_by_name("username")
password = driver.find_element_by_name("password")
time.sleep(3)
username.send_keys("admin")
password.send_keys("password")
time.sleep(5)
driver.find_element_by_name("Login").click()
time.sleep(2)
driver.get(host+"/vulnerabilities/exec/")
time.sleep(2)
driver.get(host+"/vulnerabilities/csrf/")
time.sleep(2)
driver.quit()
