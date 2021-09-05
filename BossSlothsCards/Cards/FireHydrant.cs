﻿using BossSlothsCards.MonoBehaviours;
using UnboundLib.Cards;
using UnityEngine;

namespace BossSlothsCards.Cards
{
    public class FireHydrant : CustomCard
    {

        protected override string GetTitle()
        {
            return "Fire hydrant";
        }

        protected override string GetDescription()
        {
            return "You will always fire your entire clip in one burst";
        }
        
        public override void OnAddCard(Player player, Gun gun, GunAmmo gunAmmo, CharacterData data, HealthHandler health, Gravity gravity, Block block, CharacterStatModifiers characterStats)
        {
            player.gameObject.AddComponent<FireHy_Mono>();
        }
        
        public override void SetupCard(CardInfo cardInfo, Gun gun, ApplyCardStats cardStats, CharacterStatModifiers statModifiers)
        {
            cardInfo.allowMultiple = false;
            
            gun.reloadTimeAdd = 0.15f;
            gun.timeBetweenBullets = 0.03f;
        }

        protected override CardInfoStat[] GetStats()
        {
            return new []
            {
                new CardInfoStat
                {
                    amount = "+0.15s",
                    positive = false,
                    simepleAmount = CardInfoStat.SimpleAmount.notAssigned,
                    stat = "Reload time"
                },
                new CardInfoStat
                {
                    amount = "+1",
                    positive = true,
                    simepleAmount = CardInfoStat.SimpleAmount.notAssigned,
                    stat = "Extra burst"
                }
            };
        }

        protected override CardInfo.Rarity GetRarity()
        {
            return CardInfo.Rarity.Uncommon;
        }

        protected override GameObject GetCardArt()
        {
            return null;
        }

        protected override CardThemeColor.CardThemeColorType GetTheme()
        {
            return CardThemeColor.CardThemeColorType.FirepowerYellow;
        }

        public override string GetModName()
        {
            return "BSC";
        }

        public override void OnRemoveCard()
        {
        }
        
    }
}