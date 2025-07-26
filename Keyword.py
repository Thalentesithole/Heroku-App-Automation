from SeleniumLibrary import SeleniumLibrary
from robot.api.deco import keyword
import re

sl = SeleniumLibrary()

@keyword
def extract_credentials(description, label):
    pattern = rf"{re.escape(label)}\s*([^\s]+)"
    match = re.search(pattern, description, re.IGNORECASE)
    if match:
        return match.group(1)
    else:
        raise ValueError(f"{label} not found in text")