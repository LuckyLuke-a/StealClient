# A python script to build and release steal client


import os
import shutil
import requests
import re



REPO_URL = "https://api.github.com/repos/LuckyLuke-a/Steal/releases/latest"

BUILDER_FOLDER = os.path.join("builder")


def main():
    print("Creating folders....")
    if not os.path.exists(BUILDER_FOLDER):
        os.mkdir(BUILDER_FOLDER)

    fetch_core_repo = requests.get(REPO_URL).json()
    for asset in fetch_core_repo['assets']:
        asset_name = asset['name']
        asset_url = asset['browser_download_url']

        if asset_name.startswith("steal-android"):
            print("Download android reuirements....")
            file_path = os.path.join(".", "android", "app", "libs", asset_name)
            download_file(asset_url, file_path)

            print("Build android project....")

            os.system("flutter build apk --split-per-abi")

            print("Moving files to dest folder....")

            android_flutter_apk = os.path.join(".", "build", "app", "outputs", "flutter-apk")
            for apk in os.listdir(android_flutter_apk):
                if not apk.endswith(".apk"):
                    continue
                apk_path = os.path.join(android_flutter_apk, apk)
                dest_apk_path = os.path.join(BUILDER_FOLDER, apk)
                shutil.move(apk_path, dest_apk_path)



        elif asset_name.startswith("steal-windows"):
            print("Checking wintun status....")

            wintun_path = os.path.join(".", "wintun")

            get_arch = re.search(".*-(.*?)\.exe", asset_name)
            if not get_arch:
                continue
            get_arch = get_arch.group(1)
            print(f"Get core arch: {get_arch}")


            wintun_file = os.path.join(wintun_path, "bin", get_arch, "wintun.dll")
            dest_wintun_file = os.path.join(".", "assets", "windows", "wintun.dll")
            shutil.move(wintun_file, dest_wintun_file)

            print("Moving wintun.dll")

            core_path = os.path.join(".", "assets", "windows", "steal.exe")
            download_file(asset_url, core_path)
            print("Moving steal core")

            os.system("flutter build windows")

            windows_flutter_exe = os.path.join(".", "build", "windows", "x64", "runner", "Release")

            file_name = f"steal-windows-{get_arch}"
            shutil.make_archive(file_name, 'zip', windows_flutter_exe)
            file_name_suffix = file_name+".zip"
            shutil.move(f"./{file_name_suffix}", os.path.join(BUILDER_FOLDER, file_name_suffix))

            print("Moving exe to dest folder")

    print("Finish")

def download_file(url, path):
    r = requests.get(url)
    with open(path, 'wb') as f:
        f.write(r.content)




if __name__ == "__main__":
    main()