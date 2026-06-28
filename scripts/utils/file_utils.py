from pathlib import Path


def create_folder(path: Path):

    path.mkdir(parents=True, exist_ok=True)


def file_exists(path: Path):

    return path.exists()


def delete_file(path: Path):

    if path.exists():

        path.unlink()