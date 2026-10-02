import os
import sys
import time
from appium import webdriver
from appium.options.mac import Mac2Options
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Read environment variables (defaults match your main.yaml)
APP_ID = os.environ.get("APP_ID", "dev.soufianes.flutterci")
EMAIL = os.environ.get("EMAIL", "example@mail.com")
PASSWORD = os.environ.get("PASSWORD", "password123")
OUTPUT_DIR = os.environ.get("OUTPUT_DIR", "./screenshots")

os.makedirs(OUTPUT_DIR, exist_ok=True)

def find_element(driver, wait, text_or_id):
    """Finds an element by Accessibility ID, Name, or XPath (fallback)."""
    try:
        return wait.until(EC.presence_of_element_located((AppiumBy.ACCESSIBILITY_ID, text_or_id)))
    except Exception:
        return wait.until(EC.presence_of_element_located((AppiumBy.NAME, text_or_id)))

def run_login_flow(driver, wait):
    """Emulates login.yaml"""
    print("--> Starting login.yaml flow")
    
    # extendedWaitUntil visible: "Login" (optional)
    try:
        WebDriverWait(driver, 5).until(
            EC.presence_of_element_located((AppiumBy.ACCESSIBILITY_ID, "Login"))
        )
    except Exception:
        pass

    # takeScreenshot: "login_screen1"
    driver.save_screenshot(f"{OUTPUT_DIR}/login_screen1.png")

    # assertVisible & tapOn email -> inputText
    email_el = find_element(driver, wait, "email")
    email_el.click()
    email_el.send_keys(EMAIL)

    # assertVisible & tapOn password -> inputText
    pass_el = find_element(driver, wait, "password")
    pass_el.click()
    pass_el.send_keys(PASSWORD)

    # takeScreenshot: "login_screen2"
    driver.save_screenshot(f"{OUTPUT_DIR}/login_screen2.png")

    # tapOn submit
    submit_btn = find_element(driver, wait, "submit")
    submit_btn.click()

    # runFlow: welcome.yaml
    run_welcome_flow(driver, wait)

def run_welcome_flow(driver, wait):
    """Emulates welcome.yaml"""
    print("--> Starting welcome.yaml flow")
    
    # assertVisible: "welcome"
    find_element(driver, wait, "welcome")

    # takeScreenshot: "welcome_screen"
    driver.save_screenshot(f"{OUTPUT_DIR}/welcome_screen.png")

def main():
    options = Mac2Options()
    options.bundle_id = APP_ID
    
    print(f"Launching App: {APP_ID}")
    driver = webdriver.Remote("http://127.0.0.1:4723", options=options)
    wait = WebDriverWait(driver, 15)

    try:
        # main.yaml -> runFlow: login.yaml
        run_login_flow(driver, wait)
        print("Flow completed successfully!")
    finally:
        # main.yaml -> killApp
        driver.quit()

if __name__ == "__main__":
    main()