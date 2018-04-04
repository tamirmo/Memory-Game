//
//  GameManager.swift
//  Memory Game
//
//  Created by tamir on 3/20/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation

class GameManager{
    
    // MARK: - Enums
    
    public enum Difficulty : String {
        case Beginners
        case Intermediate
        case Expert
        
        static let allValues = [Beginners, Intermediate, Expert]
        
        init?(id : Int) {
            switch id {
            case 1:
                self = .Beginners
            case 2:
                self = .Intermediate
            case 3:
                self = .Expert
            default:
                return nil
            }
        }
        
        
    }
    
    /**
     An enum for a reveal cell operation
     (invalid cell - wrong cell coordinates,
     Revealed - all went ok,
     MaxCardsRevealed - when there are already two cards revealed [timer not finished yet until unrevealing them])
     AlreadyRevealedCell - when the user clicks on the same card twice
     */
    public enum TurnResult {
        case InvalidCell
        case Revealed
        case MaxCardsRevealed
        case AlreadyRevealedCell
    }
    
    // MARK: - Properties
    
    // The number of seconds to wait until hiding two cards that do not match or hide two that does match
    private static let CARDS_REVEALED_SECONDS: Double = 1
    private static var shared: GameManager? = nil

    private var difficulty: Difficulty? = nil
    private var board: Array<Array<BoardCell>>?
    // An array containing the cells that are now revealed (should hold 0 or 1 or 2 cards)
    private var revealedCells = [BoardCell]()
    // The number of cards matched (to detect if we are in a winning situation)
    private var matchedCards: Int = 0
    private var isGameWon: Bool = false
    // The time played
    private var time: (hour: Int, minute: Int, second: Int) = (0, 0, 0)
    private var name: String = ""
    private var timeTimer: Timer? = nil
    public var delegate: GameManagerDelegate?
    
    // MARK: - Accessors
    
    class func getInstance() -> GameManager {
        if shared == nil {
            shared = GameManager()
        }
        return shared!
    }
    
    func isWon() -> Bool {
        return self.isGameWon
    }
    
    func getTime() -> (hour: Int, minute: Int, second: Int) {
        return time
    }
    
    func getName() -> String {
        return name
    }
    
    // MARK: - Methods
    
    private func getDimention(difficulty: Difficulty) -> (rows: Int, cols: Int) {
        switch difficulty{
        case Difficulty.Beginners:
            return (rows:4,cols:3)
        case Difficulty.Intermediate:
            return (rows:4,cols:4)
        case Difficulty.Expert:
            return (rows:4,cols:5)
        }
    }
    
    /**
     This method returns a tuple of the nuber of rows and columns in the current difficulty.
     */
    public func getBoardDimention() -> (rows: Int, cols: Int) {
        return getDimention(difficulty: self.difficulty!)
    }
    
    /**
     This method returns an array of all possible type (duplicated) in the given difficulty.
     It is used to initiate the board (each cell should get a type in this array.
     - Parameter difficulty: The difficulty to get types for.
     - returns: An array with all the types in the given difficulty (each twice).
     */
    func getTypesArray(difficulty: Difficulty) -> [Int] {
        let difficultyDimention = getDimention(difficulty: difficulty)
        // Calculating the number of types in the board.
        // Two cells in the board has one type
        let numOfTypes = (difficultyDimention.cols * difficultyDimention.rows) / 2
        var typesArray = [Int]()
        
        for type in 1...numOfTypes{
            typesArray.append(type)
            typesArray.append(type)
        }
        return typesArray
    }
    
    /**
     This method initialize a new game in the given difficulty.
     - Parameter difficulty: The difficulty of the game.
     */
    func initializeGame(difficulty: Difficulty, playerName: String) -> Void {
        self.difficulty = difficulty
        self.matchedCards = 0
        self.isGameWon = false
        revealedCells = [BoardCell]()
        time = (0,0,0)
        name = playerName
        
        let difficultyDimention = getDimention(difficulty: difficulty)
        // Getting all avilable types of the chosen difficulty
        var typesArr = getTypesArray(difficulty: difficulty)
        
        self.board = Array<Array<BoardCell>>()
        for row in 0...(difficultyDimention.rows - 1) {
            var currRow = Array<BoardCell>()
            for col in 0...(difficultyDimention.cols - 1) {
                // Random index for the types array
                // (each index in the types array contains a valid, non taken type of cell)
                let cellTypeIndex = Int(arc4random_uniform(UInt32(typesArr.count)))
                // Getting the type in the random index
                let cellType = typesArr.remove(at: cellTypeIndex)
                // Adding a new cell
                currRow.append(BoardCell(type: cellType, row: row, col: col))
            }
            // Adding the complete row to the board
            self.board!.append(currRow)
        }
        
        // Staring a timer to count the time
        timeTimer = Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(timeTimerElapsed),
                             userInfo: nil,
                             repeats: true)
    }
    
    /**
     Elapsed method for a timer acrivated when there are two cards revealed,
     checking if they are a match and if so, setting them as copuled.
     Any ways, updating the delegate there is a card changed
     */
    @objc func timeTimerElapsed() ->Void {
        time.second += 1
        if time.second == 60{
            time.second = 0
            time.minute += 1
            if time.minute == 60{
                time.minute = 0
                time.hour += 1
            }
        }
        
        self.delegate?.timeUpdated(time: self.time)
    }
    
    /**
     This method reveals the given cell.
     - Parameter cellRow: The row of the cell to reveal.
     - Parameter cellColumn: The column of the cell to reveal.
     - returns: An enum TurnResult indicating if the cell was revealed anf if not, why.
     */
    func revealCell(cellRow: Int, cellColumn: Int) -> TurnResult {
        // Assuming all ok
        var result: TurnResult = .Revealed
        
        let cell = getCell(cellRow: cellRow, cellColumn: cellColumn)
        if cell != nil{
            if cell!.getRevealed(){
                result = .AlreadyRevealedCell
            }
            else
            {
                if self.revealedCells.count == 1 {
                cell!.setRevealed(isRevealed: true)
                revealedCells.append(cell!)
                // Staring a timer to hide matched cards or unreveal not matched cards
                Timer.scheduledTimer(timeInterval: GameManager.CARDS_REVEALED_SECONDS,
                                                 target: self,
                                                 selector: #selector(revealTimerElapsed),
                                                 userInfo: nil,
                                                 repeats: false)
                }
                else if self.revealedCells.count == 0{
                    revealedCells.append(cell!)
                    cell!.setRevealed(isRevealed: true)
                }
                // There are two cards revealed
                else{
                    result = .MaxCardsRevealed
                }
            }
        }else{
            // The given coordinates are invalid
            result = .InvalidCell
        }
        
        return result
    }
    
    /**
     Elapsed method for a timer acrivated when there are two cards revealed,
     checking if they are a match and if so, setting them as copuled.
     Any ways, updating the delegate there is a card changed
     */
    @objc func revealTimerElapsed() ->Void {
        // If there is a match
        if revealedCells[0].getType() == revealedCells[1].getType(){
            revealedCells[0].setCoupled(isCoupled: true)
            revealedCells[1].setCoupled(isCoupled: true)
            // There are now two cards deleted, cause the player found a match
            matchedCards += 2
            
            // If the game is over, raising an event
            let gameDim = getBoardDimention()
            if gameDim.cols * gameDim.rows == matchedCards{
                delegate?.gameWon()
                self.isGameWon = true
                stopTimeTimer()
            }
        }
        // There is no match
        else{
            revealedCells[0].setRevealed(isRevealed: false)
            revealedCells[1].setRevealed(isRevealed: false)
        }
        
        // Notifying the cards changed
        delegate?.cardChanged(row: revealedCells[0].getRow(), col: revealedCells[0].getCol())
        delegate?.cardChanged(row: revealedCells[1].getRow(), col: revealedCells[1].getCol())
        
        // Clearing the revealed cells for next time
        revealedCells.removeAll()
    }
    
    func stopTimeTimer() -> Void {
        timeTimer?.invalidate()
    }
    
    func getCell(cellRow: Int, cellColumn: Int) -> BoardCell? {
        if self.board != nil && self.board!.count > cellRow &&
            self.board![cellRow].count > cellColumn {
            return self.board![cellRow][cellColumn]
        }
        return nil
    }
}
