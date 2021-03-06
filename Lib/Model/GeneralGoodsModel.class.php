<?php
import("@.Util.Goods.SortField");
import("@.Util.Goods.SourcePlace");

class GeneralGoodsModel extends Model{
	protected $_validate = array(
		array('name', 'require', "Good's name is necessary!"),
		array('price', 'require', 'Price is necessary!'),
		array('price', 'currency', 'Price is not valid!'),
		array('place', 'require', 'Place is necessary!'),
		array('stock', 'require', 'Stock is necessary!'),
		array('stock', 'number', 'Stock must be a number!'),
	);
	
	protected $_auto = array(
		array('bought_count', '0'),
		array('score', '0'),
		array('score_count', '0'),
	);

	public function findGoodsWithId($id) {
		$condition['id'] = $id;
		return $this->where($condition)->find();
	}
	
	// get goods count with purchase action
	public function getGoodsCountWithPurchaseAction($purchaseAction) {
		// get parameters from purchase action and query the conresponding database
		return $this->where($this->generateCondition($purchaseAction))->count();
	}
	
	public function getGoodsWithPurchaseActionAndPage($purchaseAction, $Page) {
		$condition = $this->generateCondition($purchaseAction);
		$selectCause = $this->where($condition);
		//sort field
		if(($sort = $purchaseAction->_get('sort_field')) && ($sort != 'nothing')) {
			$availableSortArray = $this->getSortFieldArray();
			foreach($availableSortArray as $sortField) {
				if($sortField->field == $sort) {
					$temp = $this->getSortFieldSqlArray();
					$selectCause = $selectCause->order($temp[$sort]);
				}
			}
		}
		$result = $selectCause->limit($Page->firstRow.','.$Page->listRows)->select();
		return $result;		
	}
	
	static public function getDataName() {
		return 'general_goods';
	}
	
	static protected function generateCondition($purchaseAction) {
		$keywords = $purchaseAction->_get('keywords');
		//like cause with split words
		$keywordArray = split(" +", $keywords);
		for($i = 0; $i < count($keywordArray); $i++) {
			if($keywordArray[$i]!='')
				$keywordArray[$i] = '%' . $keywordArray[$i] . '%';
		}
		$condition['name'] = array('like', $keywordArray, 'OR');
		if($keywords == '') {
			$condition['name'] = array('like', '%%');
		}
		//where cause of price range
		$priceLowerBound = $purchaseAction->_get('price-lower-bound');
		$priceUpperBound = $purchaseAction->_get('price-upper-bound');
		//lower bound : upper bound or 0 : upper bound
		if($priceUpperBound == '0' || doubleval($priceUpperBound) > 0) {
			$condition['price'] = array('between',array(doubleval($priceLowerBound), doubleval($priceUpperBound)));
		}
		//lower bound : infinite
		else if($priceLowerBound == '0' || doubleval($priceLowerBound) > 0) {
			$condition['price'] = array('egt', doubleval($priceLowerBound));
		}
		//due to airplane has no place field.
		if(($place = $purchaseAction->_get('place')) && $place != "anyplace") {
			$condition['place'] = $place;
		}
		return $condition;
	}
	
	static $sortFieldSqlArray = null;
	
	//sort field array
   	static public function getSortFieldArray() {
		return array(new SortField('sort by price ↑', 'priceAsc'),
		new SortField('sort by sales ↓', 'boughtCountDesc'),
		new SortField('sort by score ↓', 'scoreDesc'));
	}

	//sort field array with head
   	static public function getSortFieldArrayWithHead() {
		return array(new SortField('sort by nothing -', 'nothing'),
		new SortField('sort by price ↑', 'priceAsc'),
		new SortField('sort by sales ↓', 'boughtCountDesc'),
		new SortField('sort by score ↓', 'scoreDesc'));
	}

	//sort field sql array
   	static public function getSortFieldSqlArray() {
		if(!$sortFieldSqlArray) {
			$sortFieldSqlArray = array('priceAsc' => 'price asc',
				'boughtCountDesc' => 'bought_count desc',
				'scoreDesc' => 'score desc');
		}
		return $sortFieldSqlArray;
	}
	
	//source place array
	static public function getSourcePlaceObjectsArray() {
		return SourcePlace::getSourcePlaceObjectsArray();
	}
	
	//source place array with head
	static public function getSourcePlaceObjectsArrayWithHead() {
		$arrayContent = SourcePlace::getSourcePlaceObjectsArray();
		$arrayContent = array_merge(array(new SourcePlace("source place", "anyplace")), $arrayContent);
		return $arrayContent;
	}
	
	//type of this class
	static public function getType() {
		return "GeneralGoodsModel";
	}
}
?>
