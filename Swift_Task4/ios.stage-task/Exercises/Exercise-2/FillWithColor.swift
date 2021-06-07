import Foundation

final class FillWithColor {

    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        guard row >= 0 &&
                column >= 0 &&
                row < image.count &&
                column < image[0].count &&
                image.count <= 50 &&
                image[0].count <= 50 &&
                newColor < 65536 &&
                image != [[]]
        else { return image }

        let oldColor = image[row][column]
        var newImage = image
        fill(&newImage, row, column, oldColor, newColor)
        return newImage
    }

    func fill(_ image: inout [[Int]], _ row: Int, _ column: Int, _ oldColor: Int, _ newColor: Int) {
        guard
            row >= 0 &&
                column >= 0 &&
                row < image.count &&
                column < image[0].count &&
                image[row][column] == oldColor
        else { return }

        image[row][column] = newColor
        fill(&image, row + 1, column, oldColor, newColor)
        fill(&image, row - 1, column, oldColor, newColor)
        fill(&image, row, column + 1, oldColor, newColor)
        fill(&image, row, column - 1, oldColor, newColor)
    }
}
