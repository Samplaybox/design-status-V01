"""Domain models (placeholders)."""

from dataclasses import dataclass


@dataclass
class Workbook:
    name: str
    sheets: int = 0
