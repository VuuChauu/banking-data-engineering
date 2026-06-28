from pathlib import Path

import pandas as pd


def read_csv(path: Path) -> pd.DataFrame:
    """
    Read csv safely.
    """

    return pd.read_csv(path)


def save_csv(df: pd.DataFrame, path: Path):

    path.parent.mkdir(parents=True, exist_ok=True)

    df.to_csv(path, index=False)