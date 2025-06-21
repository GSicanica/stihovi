from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By

app = Flask(__name__)

@app.route('/stih')
def stih():
    ref = request.args.get('ref', 'JHN.3.16')
    url = f'https://www.bible.com/hr/bible/2475/{ref}.SHP'

    options = Options()
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')

    driver = webdriver.Chrome(options=options)

    try:
        driver.get(url)
        driver.implicitly_wait(5)
        elements = driver.find_elements(By.CLASS_NAME, 'text-text-light')

        stihovi = [el.text.strip() for el in elements if el.text.strip()]

        return jsonify({
            'reference': ref,
            'source_url': url,
            'stihovi': stihovi
        })
    except Exception as e:
        return jsonify({'error': str(e)})
    finally:
        driver.quit()

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
