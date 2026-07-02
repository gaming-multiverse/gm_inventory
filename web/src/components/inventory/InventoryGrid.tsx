import React, { useEffect, useMemo, useState } from 'react';
import { Inventory } from '../../typings';
import InventorySlot from './InventorySlot';
import { getTotalWeight } from '../../helpers';
import { useAppSelector, useAppDispatch } from '../../store';
import { fetchNui } from '../../utils/fetchNui';
import { selectItemAmount, setItemAmount } from '../../store/inventory';
import Divider from '../utils/Divider';
import SlotTooltip from '../inventory/SlotTooltip';
import { telegramEnabled } from '../../store/telegram';

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const dispatch = useAppDispatch();

  // -----------------------------
  //  Derived data
  // -----------------------------

  const isPlayerInventory = inventory.type === 'player';
  const isOtherPlayerInventory = inventory.type === 'otherplayer';
  const isStashInventory = inventory.type === 'stash';
  const isCraftInventory = inventory.type === 'crafting';
  const isShopInventory = inventory.type === 'shop';
  const isDropInventory = inventory.type === 'drop';
  const isEvidenceInventory = inventory.type === 'policeevidence';

  // Visible if:
  // - player inventory, OR
  // - non-player but has an id
  const inventoryVisible =
    isPlayerInventory || (!!inventory.id && !isPlayerInventory);

  const totalWeight = useMemo(
    () =>
      inventory.maxWeight !== undefined
        ? Math.floor(getTotalWeight(inventory.items) * 1000) / 1000
        : 0,
    [inventory.maxWeight, inventory.items]
  );

  const hotSlots = useMemo(
    () =>
      isPlayerInventory
        ? inventory.items.filter((i) => i.slot <= 5)
        : [],
    [isPlayerInventory, inventory.items]
  );

  const gridItems = useMemo(
    () =>
      isPlayerInventory
        ? inventory.items.filter((i) => i.slot > 5)
        : inventory.items,
    [isPlayerInventory, inventory.items]
  );

  const maxWeight = inventory.maxWeight ?? 0;

  // -----------------------------
  //  Global state
  // -----------------------------

  const isBusy = useAppSelector((state) => state.inventory.isBusy);
  const itemAmount = useAppSelector(selectItemAmount);
  const hoverData = useAppSelector((state) => state.tooltip);

  // -----------------------------
  //  Local state
  // -----------------------------

  const [totalMoney, setTotalMoney] = useState(0);
  const [otherPlayersMoney, setOtherPlayersMoney] = useState(0);

  // -----------------------------
  //  Effects
  // -----------------------------

  // Fetch player's money (only makes sense for player inventory)
  useEffect(() => {
    if (!isPlayerInventory) return;

    fetchNui('GetPlayerMoney')
      .then((money) => {
        if (typeof money === 'number') {
          setTotalMoney(money);
        }
      })
      .catch((err) => console.error('Error fetching player money:', err));
  }, [isPlayerInventory]);

  // Fetch other player's money (only for otherplayer inventory)
  useEffect(() => {
    if (!isOtherPlayerInventory) return;

    fetchNui('GetOtherPlayerMoney')
      .then((money) => {
        if (typeof money === 'number') {
          setOtherPlayersMoney(money);
        }
      })
      .catch((err) => console.error('Error fetching other player money:', err));
  }, [isOtherPlayerInventory]);

  // -----------------------------
  //  Handlers
  // -----------------------------

  const handleAmountChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    let value = event.target.valueAsNumber;

    if (isNaN(value) || value < 0) {
      value = 0;
    }

    value = Math.floor(value);
    event.target.valueAsNumber = value;
    dispatch(setItemAmount(value));
  };

  const handleCraftingOpen = () => {
    fetchNui('openTelegram');
  };

  const handleExit = () => {
    fetchNui('exit');
  };

  const handleGetMoney = () => {
    fetchNui('getMoney');
  };

  const handleGetOtherMoney = () => {
    fetchNui('getOtherMoney');
  };

  // -----------------------------
  //  Render helpers
  // -----------------------------

  const renderWeightInfo = () => {
    if (!maxWeight) return null;

    return (
      <>
        <span className="weight-label">{totalWeight / 1000}</span>
        /
        <span className="weight-label">{maxWeight / 1000}</span>
        <div className="weight-image"></div>
      </>
    );
  };

  // -----------------------------
  //  JSX
  // -----------------------------

  return (
    <div className="rootInventory">
      <div
        className={`inventory-grid-wrapper inventory_background ${
          inventoryVisible ? 'active' : ''
        }`}
        style={{
          pointerEvents: isBusy ? 'none' : 'auto',
        }}
      >
        {/* HEADER */}
        <div className="inventory-grid-header-wrapper">
          {isPlayerInventory && (
            <p style={{ fontSize: '25px' }}>Satchel</p>
          )}

          {isPlayerInventory && (
            <>
              <div className="inventory-control-inpuit-wrapper">
                <input
                  className="inventory-control-input"
                  type="number"
                  defaultValue={itemAmount}
                  onChange={handleAmountChange}
                  min={0}
                />
              </div>

              {telegramEnabled && (
                <button
                  style={{
                    backgroundColor: 'transparent',
                    border: '0px solid transparent',
                  }}
                  onClick={handleCraftingOpen}
                >
                  <div className="inventory-control-button-crafting"></div>
                </button>
              )}
            </>
          )}
        </div>

        {/* SECONDARY HEADER / LABELS */}
        <div className="inventory-grid-header-wrapper-secondary">
          {isOtherPlayerInventory && (
            <button
              className="inventory-control-button-money-other-player"
              onClick={handleGetOtherMoney}
            >
              Steal <div className="money-image"></div>{' '}
              {otherPlayersMoney.toFixed(2)}
            </button>
          )}

          {isCraftInventory && (
            <p style={{ fontSize: '25px', paddingBottom: '10px' }}>Crafting</p>
          )}

          {isDropInventory && (
            <p style={{ fontSize: '25px', paddingBottom: '10px' }}>Ground</p>
          )}

          {isShopInventory && (
            <p style={{ fontSize: '25px', paddingBottom: '10px' }}>{inventory.label}</p>
          )}

          {isStashInventory && (
            <p style={{ fontSize: '25px' }}>{inventory.label}</p>
          )}

          {isEvidenceInventory && (
            <p style={{ fontSize: '25px' }}>{inventory.label}</p>
          )}
        </div>

        {/* DIVIDER */}
        <div className="main-divider" />

        {/* PLAYER MONEY + WEIGHT */}
        {isPlayerInventory && (
          <>
            <div className="money-and-weight">
              <button
                className="inventory-control-button-money"
                onClick={handleGetMoney}
              >
                <div className="money-image"></div>
                {totalMoney.toFixed(2)}
              </button>

              <div className="top-weight">{renderWeightInfo()}</div>
            </div>

            <Divider />
          </>
        )}

        {/* OTHER PLAYER / STASH WEIGHT */}
        {(isOtherPlayerInventory || isStashInventory || isEvidenceInventory || isDropInventory) && (
          <>
            <div className="top-weight-other-player">
              {renderWeightInfo()}
            </div>
            <Divider />
          </>
        )}

        {/* PLAYER INVENTORY GRID (hotbar + items) */}
        {isPlayerInventory && (
          <div className="inventory-grid-container">
            {/* HOTBAR */}
            <div className="inventory-hotbar">
              {hotSlots.map((item) => (
                <InventorySlot
                  key={`hot-${item.slot}`}
                  item={item}
                  inventoryType={inventory.type}
                  inventoryGroups={inventory.groups}
                  inventoryId={inventory.id}
                />
              ))}
            </div>

            {/* ALL PLAYER ITEMS (no paging, keep it simple) */}
            {gridItems.map((item) => (
              <InventorySlot
                key={`${inventory.type}-${inventory.id}-${item.slot}`}
                item={item}
                inventoryType={inventory.type}
                inventoryGroups={inventory.groups}
                inventoryId={inventory.id}
              />
            ))}
          </div>
        )}

        {/* NON-PLAYER INVENTORY GRID (stash / other player) */}
        {!isPlayerInventory && !isCraftInventory && (
          <div className="inventory-grid-container-secondary">
            <div className="inventory-hotbar">
              {gridItems.map((item) => (
                <InventorySlot
                  key={`${inventory.type}-${inventory.id}-${item.slot}`}
                  item={item}
                  inventoryType={inventory.type}
                  inventoryGroups={inventory.groups}
                  inventoryId={inventory.id}
                />
              ))}
            </div>
          </div>
        )}

        {isCraftInventory && (
          <div className="inventory-grid-container-craft">
            {gridItems.map((item) => ( // at most 2 slots
              <InventorySlot
                key={`${inventory.type}-${inventory.id}-${item.slot}`}
                item={item}
                inventoryType={inventory.type}
                inventoryGroups={inventory.groups}
                inventoryId={inventory.id}
              />
            ))}
          </div>
        )}

        {/* PLAYER TOOLTIP + CLOSE BUTTON */}
        {isPlayerInventory && (
          <>
            <div>
              <Divider />
            </div>

            {hoverData.item && hoverData.inventoryType && (
              <SlotTooltip
                item={hoverData.item}
                inventoryType={hoverData.inventoryType}
              />
            )}

            <button
              className="inventory-control-button"
              onClick={handleExit}
            >
              Close
            </button>
          </>
        )}
      </div>
    </div>
  );
};

export default InventoryGrid;
