<?php
class dbconnection
{
	private static $server = 'server name';
	private static $db = 'db name';
	private static $user = 'user name';
	private static $pass = 'password';

	private static $instance = null;

	private $conn = null;

	public static function instance()
	{
		if(is_null(self::$instance))
			self::$instance = new dbconnection();

		return self::$instance;
	}

	function dbconnection()
	{
		$this->connection();
	}

	private function connection()
	{
        $options = array(
            PDO::ATTR_PERSISTENT    => true,
            PDO::ATTR_ERRMODE       => PDO::ERRMODE_EXCEPTION
        );

		try
		{
			$dsn = 'mysql:host='.self::$server.';dbname='.self::$db;
			$this->conn = new PDO($dsn, self::$user, self::$pass, $options);
		}
        catch(PDOException $e)
		{
            $this->error = $e->getMessage();
        }
	}
	
	function insertData($table = '', $fileds = array())
	{
		if($table == '')
			die("Can not insert data: Problem with table name");
		
		if(count($fileds) == 0)
			die("Can not insert data: Problem with fields");
		
		if(!is_array($fileds))
			die("Can not insert data: Problem with fields array");
		else
		{
			$oldkey = implode(",",array_keys($fileds));
			$value = "'".implode("','",$fileds)."'";
			
			$keyarray = array();
			foreach($fileds as $key => $val)
			{
				$newkey = ":".$key;
				$keyarray[$newkey] = $val;
			}
			$keys = implode(",",array_keys($keyarray));

			$sql = "INSERT INTO ".$table." (".$oldkey.") VALUES (".$keys.")";
			$q = $this->conn->prepare($sql);
			$q->execute($keyarray);

			return $this->conn->lastInsertId();
		}
	}

	function updateData($table = '', $fileds = array(), $where)
	{
		if($table == '')
			die("Can not update data: Problem with table name");
		
		if(count($fileds) == 0)
			die("Can not update data: Problem with fields");
		
		if(!is_array($fileds))
			die("Can not update data: Problem with fields array");
		elseif(count($where) == 0)
			die("Can not update data: Problem with where condition");
		else
		{
			$oldkey = implode(",",array_keys($fileds));
			$value = "'".implode("','",$fileds)."'";
			
			$keys = array();
			$keyarray = array();
			foreach($fileds as $key => $val)
			{
				$keys[] = $key."=:".$key;
				
				$newkey = ":".$key;
				$keyarray[$newkey] = $val;
			}
			$keyval = implode(",",$keys);

			/****** where condition array ************/
			foreach($where as $wkey => $wval)
			{
				$wkeys[] = $wkey."=:".$wkey;
				
				$wnewkey = ":".$wkey;
				$wkeyarray[$wnewkey] = $wval;
			}

			$wkeyval = implode(" and ",$wkeys);
			
			$sql = "UPDATE ".$table ." SET ".$keyval." WHERE ". $wkeyval;
			$fields = array_merge($keyarray,$wkeyarray);

			$q =  $this->conn->prepare($sql);
			return $q->execute($fields);
		}
	}

	function deleteData($table = '', $where = array())
	{
		if($table == '')
			die("Can not update data: Problem with table name");
		
		if(count($where) == 0)
			die("Can not update data: Problem with where condition");
		else
		{
			$wkeyarray = array();
			foreach($where as $wkey => $wval)
			{
				$wkeys[] = $wkey."=:".$wkey;
				
				$wnewkey = ":".$wkey;
				$wkeyarray[$wnewkey] = $wval;
			}

			$wkeyval = implode(" and ",$wkeys);

			$sql = "DELETE FROM ".$table." WHERE ".$wkeyval;
			$q = $this->conn->prepare($sql); 
			$q->execute($wkeyarray);
		}
	}

	function fetchRow($sql = '', $where  = array())
	{
		if($sql == '')
			die("problem occures with the query");
	
		$wkeyarray = array();
		foreach($where as $wkey => $wval)
		{	
			$wnewkey = ":".$wkey;
			$wkeyarray[$wnewkey] = $wval;
		}

		$q = $this->conn->prepare($sql); 
		
		$q->execute($wkeyarray);
		$row = $q->fetch(PDO::FETCH_OBJ);
		$empty = array();
		if($row == false)
			return $empty;
		else
			return $row;

	}
	
	function fetchAll($sql, $where  = array())
	{
		if($sql == '')
			die("problem occures with the query");
	
		$wkeyarray = array();
		foreach($where as $wkey => $wval)
		{	
			$wnewkey = ":".$wkey;
			$wkeyarray[$wnewkey] = $wval;
		}

		$q = $this->conn->prepare($sql); 
		$q->execute($wkeyarray);
		$row = $q->fetchAll(PDO::FETCH_ASSOC);
		
		$empty = array();
		if($row == false)
			return $empty;
		else
			return $row;
	}
}

?>
