import os
import time
from appium import webdriver
from appium.options.mac import Mac2Options
from appium.webdriver.common.appiumby import AppiumBy

APP_ID = os.environ.get("APP_ID", "dev.soufianes.flutterci")
EMAIL = os.environ.get("EMAIL", "example@mail.com")
PASSWORD = os.environ.get("PASSWORD", "password123")
OUTPUT_DIR = os.environ.get("OUTPUT_DIR", "./screenshots")

os.makedirs(OUTPUT_DIR, exist_ok=True)

def find_element(driver, identifier, timeout=15):
    """
    Fast-polling element locator with page source debug logging on failure.
    """
    end_time = time.time() + timeout
    locators = [
        (AppiumBy.ACCESSIBILITY_ID, identifier),
        (AppiumBy.NAME, identifier),
        (AppiumBy.XPATH, f'//*[@accessibility-id="{identifier}"]'),
        (AppiumBy.XPATH, f'//*[@label="{identifier}"]'),
        (AppiumBy.XPATH, f'//*[@value="{identifier}"]')
    ]
    
    while time.time() < end_time:
        for by, value in locators:
            try:
                elements = driver.find_elements(by, value)
                if elements:
                    return elements[0]
            except Exception:
                pass
        time.sleep(0.5)
        
    print(f"❌ ERROR: Could not locate element '{identifier}'. Current Page Source:")
    print(driver.page_source)
    raise Exception(f"Could not locate element: {identifier}")

def run_login_flow(driver):
    print("--> Starting login flow")
    time.sleep(3)

    driver.save_screenshot(f"{OUTPUT_DIR}/login_screen1.png")

    email_el = find_element(driver, "email")
    email_el.click()
    email_el.send_keys(EMAIL)

    pass_el = find_element(driver, "password")
    pass_el.click()
    pass_el.send_keys(PASSWORD)

    driver.save_screenshot(f"{OUTPUT_DIR}/login_screen2.png")

    submit_btn = find_element(driver, "submit")
    submit_btn.click()

def main():
    options = Mac2Options()
    options.bundle_id = APP_ID
    
    print(f"Launching App: {APP_ID}")
    driver = webdriver.Remote("http://127.0.0.1:4723", options=options)

    try:
        run_login_flow(driver)
        print("Flow completed successfully!")
    finally:
        driver.quit()

if __name__ == "__main__":
    main()