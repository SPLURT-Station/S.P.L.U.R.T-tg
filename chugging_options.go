// Chugging option expansion & speed optimization fix (#1230)
package splurt

type ChuggingOption struct {
	BeverageID  string  `json:"beverage_id"`
	SpeedFactor float64 `json:"speed_factor"`
	Animation   string  `json:"animation"`
}

func GetExpandedChuggingOptions() []ChuggingOption {
	return []ChuggingOption{
		{BeverageID: "beer_stout", SpeedFactor: 1.5, Animation: "fast_chug"},
		{BeverageID: "space_cola", SpeedFactor: 2.0, Animation: "ultra_chug"},
	}
}
