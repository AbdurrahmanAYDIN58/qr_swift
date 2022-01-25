import UIKit

class Cell: UITableViewCell {

   
    
    @IBOutlet weak var ok: UIImageView!
    
    @IBOutlet weak var bk: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
