import os
import time
from appium import webdriver
from appium.options.mac import Mac2Options
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

APP_ID = os.environ.get("APP_ID", "dev.soufianes.flutterci")
EMAIL = os.environ.get("EMAIL", "example@mail.com")
PASSWORD = os.environ.get("PASSWORD", "password123")
OUTPUT_DIR = os.environ.get("OUTPUT_DIR", "./screenshots")

os.makedirs(OUTPUT_DIR, exist_ok=True)

def find_element(driver, wait, identifier):
    """
    Attempts to locate a Flutter UI element by Accessibility ID, 
    Name, or XPath fallback.
    """
    locators = [
        (AppiumBy.ACCESSIBILITY_ID, identifier),
        (AppiumBy.NAME, identifier),
        (AppiumBy.XPATH, f'//*[@accessibility-id="{identifier}"]'),
        (AppiumBy.XPATH, f'//*[@value="{identifier}"]')
    ]
    
    for by, value in locators:
        try:
            return wait.until(EC.presence_of_element_located((by, value)))
        except Exception:
            continue
            
    raise Exception(f"Could not locate element: {identifier}")

def run_login_flow(driver, wait):
    print("--> Starting login flow")
    
    # Allow extra time for Flutter window rendering
    time.sleep(3)

    # Save initial screenshot
    driver.save_screenshot(f"{OUTPUT_DIR}/login_screen1.png")

    # Locate and interact with Email field
    email_el = find_element(driver, wait, "email")
    email_el.click()
    email_el.send_keys(EMAIL)

    # Locate and interact with Password field
    pass_el = find_element(driver, wait, "password")
    pass_el.click()
    pass_el.send_keys(PASSWORD)

    driver.save_screenshot(f"{OUTPUT_DIR}/login_screen2.png")

    # Submit form
    submit_btn = find_element(driver, wait, "submit")
    submit_btn.click()

def main():
    options = Mac2Options()
    options.bundle_id = APP_ID
    
    print(f"Launching App: {APP_ID}")
    driver = webdriver.Remote("http://127.0.0.1:4723", options=options)
    wait = WebDriverWait(driver, 10)

    try:
        run_login_flow(driver, wait)
        print("Flow completed successfully!")
    finally:
        driver.quit()

if __name__ == "__main__":
    main()